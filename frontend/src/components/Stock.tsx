import { useEffect, useRef, useState } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { createChart, IChartApi, ISeriesApi, CandlestickData, Time, HistogramData } from 'lightweight-charts';
import { MarketData, marketDataService } from '../services/marketDataService';
import { TimeInterval } from './Watchlist';
import { stockService } from '../services/stockService';
import Header from './Header';
import { authService } from '../services/authService';
import Portfolio from './Portfolio';
import Transactions from './Transactions';

interface StockInfo {
  symbol: string;
  name: string;
  exchange: string;
  mic_code: string;
  country: string;
  type: string;
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

const Stock = () => {
  const { symbol = 'AAPL' } = useParams<{ symbol: string }>();
  const navigate = useNavigate();
  const chartContainerRef = useRef<HTMLDivElement>(null);
  const [interval, setInterval] = useState<TimeInterval>('1min');
  const [isLoading, setIsLoading] = useState(false);
  const [stockInfo, setStockInfo] = useState<StockInfo | null>(null);
  const [currentPrice, setCurrentPrice] = useState<number | null>(null);
  const [symbols, setSymbols] = useState<StockInfo[]>([]);
  const [error, setError] = useState<string | null>(null);
  const chartRef = useRef<IChartApi | null>(null);
  const candlestickSeriesRef = useRef<ISeriesApi<"Candlestick"> | null>(null);
  const volumeSeriesRef = useRef<ISeriesApi<"Histogram"> | null>(null);
  const websocketRef = useRef<WebSocket | null>(null);

  const handleLogout = () => {
    authService.logout();
    navigate('/login');
  };

  // Load stock info and current price
  useEffect(() => {
    let isMounted = true;

    const loadStockData = async () => {
      try {
        const [info, price] = await Promise.all([
          stockService.getStockInfo(symbol),
          stockService.getCurrentPrice(symbol)
        ]);
        if (isMounted) {
          setStockInfo(info);
          setCurrentPrice(price);
        }
      } catch (err) {
        console.error('Error loading stock data:', err);
        if (isMounted) {
          setStockInfo(null);
          setCurrentPrice(null);
        }
      }
    };

    loadStockData();
    return () => {
      isMounted = false;
    };
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

    candlestickSeriesRef.current = candlestickSeries;
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
    let isMounted = true;

    const setupWebSocket = async () => {
      if (!candlestickSeriesRef.current || !volumeSeriesRef.current) return;

      if (websocketRef.current) {
        websocketRef.current.close();
      }

      websocketRef.current = await marketDataService.subscribeToRealtimeData(
        symbol,
        (data) => {
          if (isMounted) {
            candlestickSeriesRef.current?.update(parseData(data));
            volumeSeriesRef.current?.update(parseVolumeData(data));
          }
        }
      );
    };

    handleIntervalChange(interval);
    setupWebSocket();

    return () => {
      isMounted = false;
      websocketRef.current?.close();
    };
  }, [symbol, interval]);

  // Fetch available symbols
  useEffect(() => {
    const fetchSymbols = async () => {
      try {
        const token = authService.getToken();
        if (!token) {
          navigate('/');
          return;
        }

        const response = await fetch('http://localhost:8082/market/stocks', {
          headers: {
            'Authorization': `Bearer ${token}`,
            'Content-Type': 'application/json',
          },
        });

        if (response.status === 401) {
          navigate('/');
          return;
        }

        if (!response.ok) {
          throw new Error('Failed to fetch symbols');
        }

        const data = await response.json();
        setSymbols(data);
      } catch (err) {
        console.error('Failed to fetch symbols:', err);
      }
    };

    fetchSymbols();
  }, [navigate]);

  const handleIntervalChange = async (newInterval: TimeInterval) => {
    setIsLoading(true);
    setError(null);

    try {
      const data = await marketDataService.getHistoricalData(symbol, newInterval);
      const parsedData = data.map(parseData);
      const parsedVolumeData = data.map(parseVolumeData);
      
      if (candlestickSeriesRef.current && volumeSeriesRef.current) {
        candlestickSeriesRef.current.setData(parsedData);
        volumeSeriesRef.current.setData(parsedVolumeData);
        
        // Fit content after data is loaded
        if (chartRef.current) {
          chartRef.current.timeScale().fitContent();
        }
      }
      setInterval(newInterval);
    } catch (error) {
      console.error('Failed to load historical data:', error);
      setError('Failed to load chart data. Please try again.');
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-tradingview-bg">
      <Header 
        selectedSymbol={symbol}
        onSymbolChange={(newSymbol) => navigate(`/stock/${newSymbol}`)}
        symbols={symbols}
        onLogout={handleLogout}
      />
      
      <div className="container mx-auto px-4 py-6">
        <div className="flex gap-6">
          <div className="flex-1">
            <div className="flex flex-col space-y-6">
              {/* Stock Info Panel */}
              <div className="bg-tradingview-panel border border-tradingview-border rounded-lg p-4">
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

              {/* Chart Panel */}
              <div className="bg-tradingview-panel border border-tradingview-border rounded-lg p-4">
                <div ref={chartContainerRef} className="w-full h-[600px]" />
                {error && (
                  <div className="absolute inset-0 flex items-center justify-center">
                    <div className="bg-red-500/10 border border-red-500/20 rounded-lg px-4 py-2">
                      <p className="text-red-500">{error}</p>
                    </div>
                  </div>
                )}
              </div>

              {/* Interval Selection */}
              <div className="bg-tradingview-panel border border-tradingview-border rounded-lg p-4">
                <div className="flex items-center space-x-2">
                  <span className="text-tradingview-text/80">Interval:</span>
                  <div className="flex flex-wrap gap-2">
                    {[
                      { value: '1min', label: '1m' },
                      { value: '5min', label: '5m' },
                      { value: '15min', label: '15m' },
                      { value: '30min', label: '30m' },
                      { value: '45min', label: '45m' },
                      { value: '1h', label: '1h' },
                      { value: '2h', label: '2h' },
                      { value: '4h', label: '4h' },
                      { value: '1day', label: '1d' },
                      { value: '1week', label: '1w' },
                      { value: '1month', label: '1M' },
                    ].map(({ value, label }) => (
                      <button
                        key={value}
                        onClick={() => handleIntervalChange(value as TimeInterval)}
                        className={`px-3 py-2 rounded-md transition-all duration-200 ${
                          interval === value
                            ? 'bg-tradingview-accent text-white font-semibold shadow-lg shadow-tradingview-accent/30'
                            : 'text-tradingview-text hover:bg-tradingview-border hover:text-white'
                        }`}
                      >
                        {label}
                      </button>
                    ))}
                  </div>
                </div>
              </div>
            </div>
          </div>

          {/* Right Sidebar */}
          <div className="w-96 border-l border-tradingview-border bg-tradingview-panel rounded-lg flex flex-col">
            {/* Portfolio Section */}
            <div className="flex-1 border-b border-tradingview-border">
              <Portfolio symbol={symbol} />
            </div>

            {/* Transactions Section */}
            <div className="flex-1">
              {currentPrice !== null && (
                <Transactions symbol={symbol} currentPrice={currentPrice} />
              )}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Stock; 