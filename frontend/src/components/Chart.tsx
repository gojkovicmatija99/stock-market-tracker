import { useEffect, useRef, useState } from 'react';
import { createChart, IChartApi, ISeriesApi, CandlestickData, Time } from 'lightweight-charts';
import { MarketData, marketDataService } from '../services/marketDataService';
import { TimeInterval } from './Watchlist';
import { ArrowPathIcon } from '@heroicons/react/24/outline';

interface ChartProps {
  symbol: string;
  interval: TimeInterval;
  onLoadingChange: (isLoading: boolean) => void;
}

const parseData = (data: MarketData): CandlestickData => {
  // Convert datetime string to Unix timestamp (seconds)
  const timestamp = Math.floor(new Date(data.datetime.replace(' ', 'T')).getTime() / 1000) as Time;
  return {
    time: timestamp,
    open: parseFloat(data.open),
    high: parseFloat(data.high),
    low: parseFloat(data.low),
    close: parseFloat(data.close)
  };
};

const Chart = ({ symbol, interval, onLoadingChange }: ChartProps) => {
  const chartContainerRef = useRef<HTMLDivElement>(null);
  const chartRef = useRef<IChartApi | null>(null);
  const seriesRef = useRef<ISeriesApi<"Candlestick"> | null>(null);
  const websocketRef = useRef<WebSocket | null>(null);
  const [error, setError] = useState<string | null>(null);

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
      },
    });

    const series = chartInstance.addCandlestickSeries({
      upColor: '#26a69a',
      downColor: '#ef5350',
      borderVisible: false,
      wickUpColor: '#26a69a',
      wickDownColor: '#ef5350',
    });

    chartRef.current = chartInstance;
    seriesRef.current = series;

    const handleResize = () => {
      if (chartContainerRef.current) {
        chartInstance.applyOptions({ width: chartContainerRef.current.clientWidth });
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
      if (!seriesRef.current) return;
      
      onLoadingChange(true);
      setError(null);

      try {
        const data = await marketDataService.getHistoricalData(symbol, interval);
        const parsedData = data.map(parseData);
        seriesRef.current.setData(parsedData);
      } catch (error) {
        console.error('Failed to load historical data:', error);
        setError('Failed to load chart data. Please try again.');
      } finally {
        onLoadingChange(false);
      }
    };

    const setupWebSocket = async () => {
      if (!seriesRef.current) return;

      if (websocketRef.current) {
        websocketRef.current.close();
      }

      websocketRef.current = await marketDataService.subscribeToRealtimeData(
        symbol,
        (data) => {
          seriesRef.current?.update(parseData(data));
        }
      );
    };

    loadHistoricalData();
    setupWebSocket();

    return () => {
      websocketRef.current?.close();
    };
  }, [symbol, interval, onLoadingChange]);

  return (
    <div className="relative w-full h-[600px]">
      <div ref={chartContainerRef} className="w-full h-full" />
      {error && (
        <div className="absolute inset-0 flex items-center justify-center">
          <div className="bg-red-500/10 border border-red-500/20 rounded-lg px-4 py-2">
            <p className="text-red-500">{error}</p>
          </div>
        </div>
      )}
    </div>
  );
};

export default Chart; 