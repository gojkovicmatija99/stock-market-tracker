import { useEffect, useState } from 'react';
import { SymbolData, marketDataService } from '../services/marketDataService';
import { ArrowPathIcon } from '@heroicons/react/24/outline';

export type TimeInterval = '1min' | '5min' | '15min' | '30min' | '45min' | '1h' | '2h' | '4h' | '1day' | '1week' | '1month';

interface WatchlistItemProps {
  symbol: string;
  price: string;
  change: string;
  changePercent: string;
  isPositive: boolean;
  onRefresh: (symbol: string) => void;
  isRefreshing: boolean;
  isSelected: boolean;
  onSelect: (symbol: string) => void;
}

const intervals: TimeInterval[] = [
  '1min',
  '5min',
  '15min',
  '30min',
  '45min',
  '1h',
  '2h',
  '4h',
  '1day',
  '1week',
  '1month'
];

const WatchlistItem = ({ 
  symbol, 
  price, 
  change, 
  changePercent, 
  isPositive, 
  onRefresh,
  isRefreshing,
  isSelected,
  onSelect
}: WatchlistItemProps) => (
  <div 
    className={`flex items-center justify-between px-4 py-2 hover:bg-tradingview-panel cursor-pointer group ${isSelected ? 'bg-tradingview-panel' : ''}`}
    onClick={() => onSelect(symbol)}
  >
    <div className="text-tradingview-text">
      <div className="font-medium">{symbol}</div>
    </div>
    <div className="flex items-center gap-2">
      <div className="text-right">
        <div className="text-tradingview-text">{parseFloat(price).toFixed(2)}</div>
        <div className={`text-sm ${isPositive ? 'text-green-500' : 'text-red-500'}`}>
          {parseFloat(change).toFixed(2)} ({parseFloat(changePercent).toFixed(2)}%)
        </div>
      </div>
      <button 
        onClick={(e) => {
          e.stopPropagation();
          onRefresh(symbol);
        }}
        className={`p-1 rounded-full hover:bg-tradingview-border opacity-0 group-hover:opacity-100 transition-opacity ${isRefreshing ? 'animate-spin' : ''}`}
      >
        <ArrowPathIcon className="h-4 w-4 text-tradingview-text" />
      </button>
    </div>
  </div>
);

const Watchlist = () => {
  const [watchlistData, setWatchlistData] = useState<SymbolData[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [refreshingSymbols, setRefreshingSymbols] = useState<Set<string>>(new Set());
  const [selectedSymbol, setSelectedSymbol] = useState<string | null>(null);
  const [selectedInterval, setSelectedInterval] = useState<TimeInterval>('15min');
  const [symbols, setSymbols] = useState<string[]>([]);
  const [newSymbol, setNewSymbol] = useState('');
  const [isLoading, setIsLoading] = useState(false);

  const handleRefresh = async (symbol: string) => {
    if (refreshingSymbols.has(symbol)) return;
    
    setRefreshingSymbols(prev => new Set([...prev, symbol]));
    try {
      const updatedData = await marketDataService.refreshSymbolData(symbol, selectedInterval);
      setWatchlistData(prev => 
        prev.map(item => item.symbol === symbol ? updatedData : item)
      );
    } catch (err) {
      console.error(`Error refreshing ${symbol}:`, err);
    } finally {
      setRefreshingSymbols(prev => {
        const next = new Set(prev);
        next.delete(symbol);
        return next;
      });
    }
  };

  // Initial load of all symbols
  useEffect(() => {
    const fetchInitialData = async () => {
      try {
        const data = await marketDataService.getWatchlistData(symbols, selectedInterval);
        setWatchlistData(data);
        if (!selectedSymbol && data.length > 0) {
          setSelectedSymbol(data[0].symbol);
        }
        setError(null);
      } catch (err) {
        setError('Failed to fetch watchlist data');
        console.error('Error fetching watchlist data:', err);
      } finally {
        setLoading(false);
      }
    };

    fetchInitialData();
  }, [selectedInterval]);

  // Auto-refresh only selected symbol
  useEffect(() => {
    if (!selectedSymbol) return;

    const refreshSelectedSymbol = async () => {
      try {
        const updatedData = await marketDataService.refreshSymbolData(selectedSymbol, selectedInterval);
        setWatchlistData(prev => 
          prev.map(item => item.symbol === selectedSymbol ? updatedData : item)
        );
      } catch (err) {
        console.error(`Error refreshing ${selectedSymbol}:`, err);
      }
    };

    refreshSelectedSymbol();
    const interval = setInterval(refreshSelectedSymbol, 5000);

    return () => clearInterval(interval);
  }, [selectedSymbol, selectedInterval]);

  if (loading) {
    return (
      <div className="w-72 bg-tradingview-bg border-l border-tradingview-border">
        <div className="h-12 flex items-center px-4 border-b border-tradingview-border">
          <h2 className="text-tradingview-text font-medium">Watchlist</h2>
        </div>
        <div className="p-4 text-tradingview-text">Loading...</div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="w-72 bg-tradingview-bg border-l border-tradingview-border">
        <div className="h-12 flex items-center px-4 border-b border-tradingview-border">
          <h2 className="text-tradingview-text font-medium">Watchlist</h2>
        </div>
        <div className="p-4 text-red-500">{error}</div>
      </div>
    );
  }

  return (
    <div className="w-72 bg-tradingview-bg border-l border-tradingview-border">
      <div className="h-12 flex items-center justify-between px-4 border-b border-tradingview-border">
        <h2 className="text-tradingview-text font-medium">Watchlist</h2>
        <select
          value={selectedInterval}
          onChange={(e) => setSelectedInterval(e.target.value as TimeInterval)}
          className="bg-tradingview-bg text-tradingview-text border border-tradingview-border rounded px-2 py-1 text-sm focus:outline-none focus:ring-1 focus:ring-blue-500"
        >
          {intervals.map(interval => (
            <option key={interval} value={interval}>
              {interval}
            </option>
          ))}
        </select>
      </div>
      <div className="overflow-y-auto">
        {watchlistData.map((item) => (
          <WatchlistItem
            key={item.symbol}
            symbol={item.symbol}
            price={item.price}
            change={item.change}
            changePercent={item.changePercent}
            isPositive={parseFloat(item.change) > 0}
            onRefresh={handleRefresh}
            isRefreshing={refreshingSymbols.has(item.symbol)}
            isSelected={item.symbol === selectedSymbol}
            onSelect={setSelectedSymbol}
          />
        ))}
      </div>
    </div>
  );
};

export default Watchlist; 