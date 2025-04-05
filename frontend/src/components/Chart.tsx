import { useEffect, useRef, useState } from 'react';
import { createChart, IChartApi, ISeriesApi, CandlestickData, Time, LineData, HistogramData } from 'lightweight-charts';
import { MarketData, marketDataService } from '../services/marketDataService';
import { TimeInterval } from './Watchlist';
import Header from './Header';

interface ChartProps {
  symbol: string;
  interval: TimeInterval;
  onLoadingChange: (isLoading: boolean) => void;
  onSymbolChange: (symbol: string) => void;
}

type ChartType = 'candlestick' | 'line';

const parseData = (data: MarketData, chartType: ChartType): CandlestickData | LineData => {
  const timestamp = Math.floor(new Date(data.datetime.replace(' ', 'T')).getTime() / 1000) as Time;
  
  if (chartType === 'candlestick') {
    return {
      time: timestamp,
      open: parseFloat(data.open),
      high: parseFloat(data.high),
      low: parseFloat(data.low),
      close: parseFloat(data.close)
    };
  } else {
    return {
      time: timestamp,
      value: parseFloat(data.close)
    };
  }
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
  const seriesRef = useRef<ISeriesApi<"Candlestick" | "Line"> | null>(null);
  const volumeSeriesRef = useRef<ISeriesApi<"Histogram"> | null>(null);
  const websocketRef = useRef<WebSocket | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [chartType, setChartType] = useState<ChartType>('candlestick');

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

    // Create initial series based on chart type
    const createSeries = () => {
      if (chartType === 'candlestick') {
        return chartInstance.addCandlestickSeries({
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
      } else {
        return chartInstance.addLineSeries({
          color: '#26a69a',
          lineWidth: 2,
          priceFormat: {
            type: 'price',
            precision: 2,
          },
        });
      }
    };

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

    seriesRef.current = createSeries();
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
  }, [chartType]);

  // Load data and setup websocket
  useEffect(() => {
    const loadHistoricalData = async () => {
      if (!seriesRef.current || !volumeSeriesRef.current) return;
      
      onLoadingChange(true);
      setError(null);

      try {
        const data = await marketDataService.getHistoricalData(symbol, interval);
        const parsedData = data.map(d => parseData(d, chartType));
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
          seriesRef.current?.update(parseData(data, chartType));
          volumeSeriesRef.current?.update(parseVolumeData(data));
        }
      );
    };

    loadHistoricalData();
    setupWebSocket();

    return () => {
      websocketRef.current?.close();
    };
  }, [symbol, interval, onLoadingChange, chartType]);

  const handleChartTypeChange = (type: ChartType) => {
    setChartType(type);
  };

  return (
    <div className="relative w-full">
      <Header 
        symbol={symbol}
        onSymbolChange={onSymbolChange}
      />
      <div className="container mx-auto px-4">
        <div className="h-[600px]">
          <div ref={chartContainerRef} className="w-full h-full" />
          {error && (
            <div className="absolute inset-0 flex items-center justify-center">
              <div className="bg-red-500/10 border border-red-500/20 rounded-lg px-4 py-2">
                <p className="text-red-500">{error}</p>
              </div>
            </div>
          )}
        </div>
      </div>
    </div>
  );
};

export default Chart; 