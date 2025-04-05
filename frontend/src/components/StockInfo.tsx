import { useEffect, useState } from 'react';
import { ArrowPathIcon } from '@heroicons/react/24/outline';
import { stockService } from '../services/stockService';
import Transactions from './Transactions';

interface StockInfoProps {
  symbol: string;
  onPriceUpdate: (price: number) => void;
}

const StockInfo = ({ symbol, onPriceUpdate }: StockInfoProps) => {
  const [currentPrice, setCurrentPrice] = useState<number | null>(null);
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const loadStockData = async () => {
    setIsLoading(true);
    setError(null);
    try {
      const data = await stockService.getStockData(symbol);
      setCurrentPrice(data.price);
      onPriceUpdate(data.price);
    } catch (err) {
      setError('Failed to load stock data');
      console.error('Error loading stock data:', err);
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    loadStockData();
    const interval = setInterval(loadStockData, 60000); // Update every minute

    return () => clearInterval(interval);
  }, [symbol]);

  if (isLoading) {
    return (
      <div className="p-4 bg-tradingview-panel border-t border-tradingview-border">
        <div className="flex items-center justify-center space-x-2 text-tradingview-text">
          <ArrowPathIcon className="h-4 w-4 animate-spin" />
          <span>Loading stock data...</span>
        </div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="p-4 bg-tradingview-panel border-t border-tradingview-border">
        <div className="p-2 bg-red-500/10 border border-red-500/20 rounded">
          <p className="text-red-500 text-sm">{error}</p>
        </div>
      </div>
    );
  }

  return (
    <div className="bg-tradingview-panel">
      <div className="p-4 border-b border-tradingview-border">
        <div className="flex items-center justify-between">
          <h2 className="text-lg font-medium text-tradingview-text">{symbol}</h2>
          <div className="text-tradingview-text">
            ${currentPrice?.toFixed(2) || '0.00'}
          </div>
        </div>
      </div>
      {currentPrice && <Transactions symbol={symbol} currentPrice={currentPrice} />}
    </div>
  );
};

export default StockInfo; 