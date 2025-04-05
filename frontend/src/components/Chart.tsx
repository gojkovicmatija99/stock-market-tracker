import { useEffect, useRef, useState } from 'react';
import { createChart, IChartApi, ISeriesApi, CandlestickData, Time, HistogramData } from 'lightweight-charts';
import { MarketData, marketDataService } from '../services/marketDataService';
import { TimeInterval } from './Watchlist';
import { stockService } from '../services/stockService';

interface ChartProps {
  symbol: string;
  interval: TimeInterval;
  onLoadingChange: (isLoading: boolean) => void;
  onSymbolChange: (symbol: string) => void;
}

const parseData = (data: MarketData): CandlestickData => {
  const timestamp = Math.floor(new Date(data.datetime.replace(' ', 'T')).getTime() / 1000) as Time;
  return {
    time: timestamp,
    open: parseFloat(data.open),
    high: parseFloat(data.high),
    low: parseFloat(data.low),
    close: parseFloat(data.close)
  };
};

const parseVolumeData = (data: MarketData): HistogramData => {
  const timestamp = Math.floor(new Date(data.datetime.replace(' ', 'T')).getTime() / 1000) as Time;
  return {
    time: timestamp,
    value: parseFloat(data.volume)
  };
};

const Chart = ({ symbol, interval, onLoadingChange, onSymbolChange }: ChartProps) => {
  const chartContainerRef = useRef<HTMLDivElement>(null);
  const chartRef = useRef<IChartApi | null>(null);
  const seriesRef = useRef<ISeriesApi<"Candlestick"> | null>(null);
  const volumeSeriesRef = useRef<ISeriesApi<"Histogram"> | null>(null);
  const websocketRef = useRef<WebSocket | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [currentPrice, setCurrentPrice] = useState<number | null>(null);
  const [stockInfo, setStockInfo] = useState<{
    symbol: string;
    name: string;
    exchange: string;
    mic_code: string;
    country: string;
    type: string;
  } | null>(null);

  // Load stock info and current price
  useEffect(() => {
    const loadStockData = async () => {
      try {
        const [info, price] = await Promise.all([
          stockService.getStockInfo(symbol),
          stockService.getCurrentPrice(symbol)
        ]);
        setStockInfo(info);
        setCurrentPrice(price);
      } catch (err) {
        console.error('Error loading stock data:', err);
        setStockInfo(null);
        setCurrentPrice(null);
      }
    };
    loadStockData();
  }, [symbol]);

  // Initialize chart
  useEffect(() => {
    if (!chartContainerRef.current) return;

    const chartInstance = createChart(chartContainerRef.current, {
      layout: {
        background: { color: '#131722' },
        textColor: '#d1d4dc',
      },
      grid: {
        vertLines: { color: '#1e222d' },
        horzLines: { color: '#1e222d' },
      },
      width: chartContainerRef.current.clientWidth,
      height: 600,
      crosshair: {
        mode: 1,
        vertLine: {
          width: 1,
          color: '#758696',
          style: 3,
        },
        horzLine: {
          width: 1,
          color: '#758696',
          style: 3,
        },
      },
      timeScale: {
        timeVisible: true,
        secondsVisible: false,
        fixLeftEdge: true,
        fixRightEdge: true,
        lockVisibleTimeRangeOnResize: true,
        rightOffset: 12,
        barSpacing: 12,
        minBarSpacing: 10,
      },
    });

    // Create candlestick series
    const candlestickSeries = chartInstance.addCandlestickSeries({
      upColor: '#26a69a',
      downColor: '#ef5350',
      borderVisible: false,
      wickUpColor: '#26a69a',
      wickDownColor: '#ef5350',
      priceFormat: {
        type: 'price',
        precision: 2,
      },
    });

    // Create volume series
    const volumeSeries = chartInstance.addHistogramSeries({
      color: '#26a69a80',
      priceFormat: {
        type: 'volume',
        precision: 0,
        minMove: 1,
      },
      priceScaleId: 'volume',
      lastValueVisible: true,
      priceLineVisible: true,
      priceLineWidth: 1,
      priceLineColor: '#26a69a',
      priceLineStyle: 2,
    });

    // Set the volume series to use a separate price scale
    volumeSeries.priceScale().applyOptions({
      scaleMargins: {
        top: 0.8,
        bottom: 0,
      },
      visible: true,
      borderVisible: false,
      borderColor: '#26a69a',
      textColor: '#d1d4dc',
      autoScale: true,
    });

    seriesRef.current = candlestickSeries;
    volumeSeriesRef.current = volumeSeries;
    chartRef.current = chartInstance;

    // Fit content after initial data load
    const fitContent = () => {
      chartInstance.timeScale().fitContent();
    };

    // Add event listener for data updates
    chartInstance.subscribeCrosshairMove(() => {
      fitContent();
    });

    const handleResize = () => {
      if (chartContainerRef.current) {
        chartInstance.applyOptions({ width: chartContainerRef.current.clientWidth });
        fitContent();
      }
    };

    window.addEventListener('resize', handleResize);

    return () => {
      window.removeEventListener('resize', handleResize);
      websocketRef.current?.close();
      chartInstance.remove();
    };
  }, []);

  // Load data and setup websocket
  useEffect(() => {
    const loadHistoricalData = async () => {
      if (!seriesRef.current || !volumeSeriesRef.current) return;
      
      onLoadingChange(true);
      setError(null);

      try {
        const data = await marketDataService.getHistoricalData(symbol, interval);
        const parsedData = data.map(parseData);
        const parsedVolumeData = data.map(parseVolumeData);
        seriesRef.current.setData(parsedData);
        volumeSeriesRef.current.setData(parsedVolumeData);
        
        // Fit content after data is loaded
        if (chartRef.current) {
          chartRef.current.timeScale().fitContent();
        }
      } catch (error) {
        console.error('Failed to load historical data:', error);
        setError('Failed to load chart data. Please try again.');
      } finally {
        onLoadingChange(false);
      }
    };

    const setupWebSocket = async () => {
      if (!seriesRef.current || !volumeSeriesRef.current) return;

      if (websocketRef.current) {
        websocketRef.current.close();
      }

      websocketRef.current = await marketDataService.subscribeToRealtimeData(
        symbol,
        (data) => {
          seriesRef.current?.update(parseData(data));
          volumeSeriesRef.current?.update(parseVolumeData(data));
        }
      );
    };

    loadHistoricalData();
    setupWebSocket();

    return () => {
      websocketRef.current?.close();
    };
  }, [symbol, interval, onLoadingChange]);

  const handleIntervalChange = async (newInterval: TimeInterval) => {
    onLoadingChange(true);
    setError(null);

    try {
      const data = await marketDataService.getHistoricalData(symbol, newInterval);
      const parsedData = data.map(parseData);
      const parsedVolumeData = data.map(parseVolumeData);
      
      if (seriesRef.current && volumeSeriesRef.current) {
        seriesRef.current.setData(parsedData);
        volumeSeriesRef.current.setData(parsedVolumeData);
        
        // Fit content after data is loaded
        if (chartRef.current) {
          chartRef.current.timeScale().fitContent();
        }
      }
    } catch (error) {
      console.error('Failed to load historical data:', error);
      setError('Failed to load chart data. Please try again.');
    } finally {
      onLoadingChange(false);
    }
  };

  return (
    <div className="flex flex-col">
      <div className="bg-tradingview-panel border border-tradingview-border rounded-lg p-4 mb-4">
        <div className="flex flex-col space-y-4">
          <div className="flex items-center justify-between">
            <div className="flex items-center space-x-2">
              <h2 className="text-2xl font-bold text-tradingview-text">
                {stockInfo?.name || 'Loading...'}
              </h2>
              <span className="text-xl text-tradingview-text/80">
                ({stockInfo?.symbol || symbol})
              </span>
            </div>
            <div className="text-2xl font-bold text-tradingview-text">
              {currentPrice !== null ? `$${currentPrice.toFixed(2)}` : 'Loading...'}
            </div>
          </div>
          <div className="flex items-center space-x-6 text-sm">
            <div className="flex items-center space-x-2">
              <span className="text-tradingview-text/60">Exchange:</span>
              <span className="text-tradingview-text">{stockInfo?.exchange || '-'}</span>
            </div>
            <div className="flex items-center space-x-2">
              <span className="text-tradingview-text/60">MIC Code:</span>
              <span className="text-tradingview-text">{stockInfo?.mic_code || '-'}</span>
            </div>
            <div className="flex items-center space-x-2">
              <span className="text-tradingview-text/60">Country:</span>
              <span className="text-tradingview-text">{stockInfo?.country || '-'}</span>
            </div>
            <div className="flex items-center space-x-2">
              <span className="text-tradingview-text/60">Type:</span>
              <span className="text-tradingview-text">{stockInfo?.type || '-'}</span>
            </div>
          </div>
        </div>
      </div>
      <div className="bg-tradingview-panel border border-tradingview-border rounded-lg p-4 mb-4">
        <div ref={chartContainerRef} className="w-full h-full" />
        {error && (
          <div className="absolute inset-0 flex items-center justify-center">
            <div className="bg-red-500/10 border border-red-500/20 rounded-lg px-4 py-2">
              <p className="text-red-500">{error}</p>
            </div>
          </div>
        )}
      </div>
      <div className="bg-tradingview-panel border border-tradingview-border rounded-lg p-4">
        <div className="flex items-center space-x-2">
          <span className="text-tradingview-text/80">Interval:</span>
          <div className="flex flex-wrap gap-2">
            <button
              onClick={() => handleIntervalChange('1min')}
              className={`px-3 py-2 rounded-md transition-all duration-200 ${
                interval === '1min'
                  ? 'bg-tradingview-accent text-white font-semibold shadow-lg shadow-tradingview-accent/30'
                  : 'text-tradingview-text hover:bg-tradingview-border hover:text-white'
              }`}
            >
              1m
            </button>
            <button
              onClick={() => handleIntervalChange('5min')}
              className={`px-3 py-2 rounded-md transition-all duration-200 ${
                interval === '5min'
                  ? 'bg-tradingview-accent text-white font-semibold shadow-lg shadow-tradingview-accent/30'
                  : 'text-tradingview-text hover:bg-tradingview-border hover:text-white'
              }`}
            >
              5m
            </button>
            <button
              onClick={() => handleIntervalChange('15min')}
              className={`px-3 py-2 rounded-md transition-all duration-200 ${
                interval === '15min'
                  ? 'bg-tradingview-accent text-white font-semibold shadow-lg shadow-tradingview-accent/30'
                  : 'text-tradingview-text hover:bg-tradingview-border hover:text-white'
              }`}
            >
              15m
            </button>
            <button
              onClick={() => handleIntervalChange('30min')}
              className={`px-3 py-2 rounded-md transition-all duration-200 ${
                interval === '30min'
                  ? 'bg-tradingview-accent text-white font-semibold shadow-lg shadow-tradingview-accent/30'
                  : 'text-tradingview-text hover:bg-tradingview-border hover:text-white'
              }`}
            >
              30m
            </button>
            <button
              onClick={() => handleIntervalChange('45min')}
              className={`px-3 py-2 rounded-md transition-all duration-200 ${
                interval === '45min'
                  ? 'bg-tradingview-accent text-white font-semibold shadow-lg shadow-tradingview-accent/30'
                  : 'text-tradingview-text hover:bg-tradingview-border hover:text-white'
              }`}
            >
              45m
            </button>
            <button
              onClick={() => handleIntervalChange('1h')}
              className={`px-3 py-2 rounded-md transition-all duration-200 ${
                interval === '1h'
                  ? 'bg-tradingview-accent text-white font-semibold shadow-lg shadow-tradingview-accent/30'
                  : 'text-tradingview-text hover:bg-tradingview-border hover:text-white'
              }`}
            >
              1h
            </button>
            <button
              onClick={() => handleIntervalChange('2h')}
              className={`px-3 py-2 rounded-md transition-all duration-200 ${
                interval === '2h'
                  ? 'bg-tradingview-accent text-white font-semibold shadow-lg shadow-tradingview-accent/30'
                  : 'text-tradingview-text hover:bg-tradingview-border hover:text-white'
              }`}
            >
              2h
            </button>
            <button
              onClick={() => handleIntervalChange('4h')}
              className={`px-3 py-2 rounded-md transition-all duration-200 ${
                interval === '4h'
                  ? 'bg-tradingview-accent text-white font-semibold shadow-lg shadow-tradingview-accent/30'
                  : 'text-tradingview-text hover:bg-tradingview-border hover:text-white'
              }`}
            >
              4h
            </button>
            <button
              onClick={() => handleIntervalChange('1day')}
              className={`px-3 py-2 rounded-md transition-all duration-200 ${
                interval === '1day'
                  ? 'bg-tradingview-accent text-white font-semibold shadow-lg shadow-tradingview-accent/30'
                  : 'text-tradingview-text hover:bg-tradingview-border hover:text-white'
              }`}
            >
              1d
            </button>
            <button
              onClick={() => handleIntervalChange('1week')}
              className={`px-3 py-2 rounded-md transition-all duration-200 ${
                interval === '1week'
                  ? 'bg-tradingview-accent text-white font-semibold shadow-lg shadow-tradingview-accent/30'
                  : 'text-tradingview-text hover:bg-tradingview-border hover:text-white'
              }`}
            >
              1w
            </button>
            <button
              onClick={() => handleIntervalChange('1month')}
              className={`px-3 py-2 rounded-md transition-all duration-200 ${
                interval === '1month'
                  ? 'bg-tradingview-accent text-white font-semibold shadow-lg shadow-tradingview-accent/30'
                  : 'text-tradingview-text hover:bg-tradingview-border hover:text-white'
              }`}
            >
              1M
            </button>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Chart; 