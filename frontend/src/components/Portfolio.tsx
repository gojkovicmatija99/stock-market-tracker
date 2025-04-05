import { useEffect, useState } from 'react';
import { authService } from '../services/authService';

interface Holding {
  symbol: string;
  positionAmount: number;
  positionPrice: number;
  profitLoss: number;
}

interface Portfolio {
  datetime: string;
  holdingList: Holding[];
  totalProfitLoss: number;
}

interface PortfolioProps {
  symbol: string;
}

const Portfolio = ({ symbol }: PortfolioProps) => {
  const [portfolio, setPortfolio] = useState<Portfolio | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const fetchPortfolio = async () => {
    setLoading(true);
    setError(null);
    try {
      const response = await fetch('http://localhost:8083/portfolio', {
        headers: {
          'Authorization': `Bearer ${authService.getToken()}`,
          'Content-Type': 'application/json',
        },
      });

      if (!response.ok) {
        throw new Error('Failed to fetch portfolio data');
      }

      const data = await response.json();
      setPortfolio(data);
    } catch (err) {
      console.error('Failed to fetch portfolio:', err);
      setError('Failed to load portfolio data');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchPortfolio();
  }, [symbol]); // Refresh when symbol changes

  if (loading) {
    return (
      <div className="bg-tradingview-bg border border-tradingview-border rounded-lg p-4">
        <div className="animate-pulse">
          <div className="h-4 bg-tradingview-border rounded w-1/4 mb-4"></div>
          <div className="space-y-3">
            <div className="h-4 bg-tradingview-border rounded w-3/4"></div>
            <div className="h-4 bg-tradingview-border rounded w-1/2"></div>
          </div>
        </div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="bg-tradingview-bg border border-tradingview-border rounded-lg p-4">
        <div className="text-red-500">{error}</div>
      </div>
    );
  }

  if (!portfolio) {
    return (
      <div className="bg-tradingview-bg border border-tradingview-border rounded-lg p-4">
        <h2 className="text-lg font-semibold text-tradingview-text mb-4">Portfolio</h2>
        <div className="text-tradingview-text/80">No portfolio data available</div>
      </div>
    );
  }

  // Find the holding for the current symbol
  const currentHolding = portfolio.holdingList.find(h => h.symbol === symbol);

  if (!currentHolding) {
    return (
      <div className="bg-tradingview-bg border border-tradingview-border rounded-lg p-4">
        <h2 className="text-lg font-semibold text-tradingview-text mb-4">Portfolio</h2>
        <div className="text-tradingview-text/80">No position in {symbol}</div>
      </div>
    );
  }

  return (
    <div className="bg-tradingview-bg border border-tradingview-border rounded-lg p-4">
      <h2 className="text-lg font-semibold text-tradingview-text mb-4">Portfolio</h2>
      <div className="space-y-3">
        <div className="flex justify-between items-center">
          <span className="text-tradingview-text/80">Position Amount:</span>
          <span className="text-tradingview-text">{currentHolding.positionAmount}</span>
        </div>
        <div className="flex justify-between items-center">
          <span className="text-tradingview-text/80">Position Price:</span>
          <span className="text-tradingview-text">${currentHolding.positionPrice.toFixed(2)}</span>
        </div>
        <div className="flex justify-between items-center">
          <span className="text-tradingview-text/80">Position Value:</span>
          <span className="text-tradingview-text">${(currentHolding.positionAmount * currentHolding.positionPrice).toFixed(2)}</span>
        </div>
        <div className="flex justify-between items-center">
          <span className="text-tradingview-text/80">Profit/Loss:</span>
          <span className={`${currentHolding.profitLoss >= 0 ? 'text-green-500' : 'text-red-500'}`}>
            ${currentHolding.profitLoss.toFixed(2)}
          </span>
        </div>
        <div className="mt-4 pt-4 border-t border-tradingview-border">
          <div className="flex justify-between items-center">
            <span className="text-tradingview-text/80">Total Portfolio P/L:</span>
            <span className={`${portfolio.totalProfitLoss >= 0 ? 'text-green-500' : 'text-red-500'}`}>
              ${portfolio.totalProfitLoss.toFixed(2)}
            </span>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Portfolio; 