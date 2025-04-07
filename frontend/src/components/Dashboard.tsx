import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { ArrowUpIcon } from '@heroicons/react/24/solid';
import { authService } from '../services/authService';
import Header from './Header';

interface AccountSummary {
  accountId: string;
  settledCash: number;
  unrealizedPL: number;
  realizedPL: number;
  maintenanceMargin: number;
  excessLiquidity: number;
  buyingPower: number;
  dividends: number;
}

interface Position {
  symbol: string;
  mktValue: number;
  last: number;
  change: number;
  description: string;
}

interface Holding {
  symbol: string;
  positionAmount: number;
  positionPrice: number;
  profitLoss: number;
}

interface Portfolio {
  datetime: string | null;
  holdingList: Holding[];
  totalProfitLoss: number;
}

interface NewsItem {
  title: string;
  source: string;
  timeAgo: string;
  readTime: string;
}

interface Stock {
  symbol: string;
  name: string;
  exchange: string;
  mic_code: string;
  country: string;
  type: string;
}

const Dashboard = () => {
  const navigate = useNavigate();
  const [selectedTimeframe, setSelectedTimeframe] = useState<'7D' | 'MTD' | 'YTD' | '1Y' | 'All'>('All');
  const [portfolio, setPortfolio] = useState<Portfolio | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [selectedSymbol, setSelectedSymbol] = useState<string>('AAPL');
  const [symbols, setSymbols] = useState<Stock[]>([]);
  
  const accountSummary: AccountSummary = {
    accountId: 'U12670526',
    settledCash: 50.06,
    unrealizedPL: 221.93,
    realizedPL: 0.00,
    maintenanceMargin: 0.00,
    excessLiquidity: 50.06,
    buyingPower: 50.06,
    dividends: 0.00
  };

  const news: NewsItem[] = [
    {
      title: 'PREVIEW-Samsung Q1 profit to drop 21% on weak AI chip sales, foundry losses',
      source: 'Reuters News',
      timeAgo: '8 hours ago',
      readTime: '3 min read'
    }
  ];

  const handleLogout = () => {
    authService.logout();
  };

  // Fetch initial symbols
  useEffect(() => {
    const fetchSymbols = async () => {
      try {
        const token = authService.getToken();
        if (!token) {
          authService.logout();
          return;
        }

        const response = await fetch('http://localhost:8083/stocks', {
          headers: {
            'Authorization': `Bearer ${token}`,
            'Content-Type': 'application/json',
          },
        });

        if (response.status === 401) {
          authService.logout();
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
  }, []);

  useEffect(() => {
    const fetchPortfolio = async () => {
      setIsLoading(true);
      setError(null);
      try {
        const token = authService.getToken();
        if (!token) {
          authService.logout();
          return;
        }

        const response = await fetch('http://localhost:8083/portfolio', {
          headers: {
            'Authorization': `Bearer ${token}`,
            'Content-Type': 'application/json',
          },
        });

        if (response.status === 401) {
          authService.logout();
          return;
        }

        if (!response.ok) {
          throw new Error('Failed to fetch portfolio data');
        }

        const data = await response.json();
        setPortfolio(data);
      } catch (err) {
        console.error('Failed to fetch portfolio:', err);
        setError('Failed to load portfolio data');
      } finally {
        setIsLoading(false);
      }
    };

    fetchPortfolio();

    // Set up interval to fetch portfolio data every minute
    const intervalId = setInterval(fetchPortfolio, 60000);

    // Cleanup interval on component unmount
    return () => clearInterval(intervalId);
  }, []);

  const handleSymbolClick = (symbol: string) => {
    navigate(`/stock/${symbol}`);
  };

  return (
    <div className="min-h-screen bg-tradingview-bg">
      <Header 
        selectedSymbol={selectedSymbol}
        onSymbolChange={(symbol) => navigate(`/stock/${symbol}`)}
        symbols={symbols}
        onLogout={handleLogout}
      />
      
      <div className="container mx-auto px-4 py-6">
        {/* Account Summary */}
        <div className="grid grid-cols-4 gap-6">
          <div className="col-span-1">
            <div className="bg-tradingview-panel border border-tradingview-border rounded-lg p-4">
              <div className="flex justify-between items-center mb-4">
                <div>
                  <span className="text-tradingview-text/60">Account</span>
                  <div className="flex items-center gap-2">
                    <span className="text-tradingview-text">{accountSummary.accountId}</span>
                    <button className="text-tradingview-text/60 hover:text-tradingview-text">📋</button>
                  </div>
                </div>
                <span className="text-xl font-semibold text-tradingview-text">€ {(7496.09).toLocaleString('en-US', { minimumFractionDigits: 2 })}</span>
              </div>

              <div className="space-y-2">
                {Object.entries({
                  'Settled Cash': accountSummary.settledCash,
                  'Unrealized P&L': accountSummary.unrealizedPL,
                  'Realized P&L': accountSummary.realizedPL,
                  'Maintenance Margin': accountSummary.maintenanceMargin,
                  'Excess Liquidity': accountSummary.excessLiquidity,
                  'Buying Power': accountSummary.buyingPower,
                  'Dividends': accountSummary.dividends
                }).map(([label, value]) => (
                  <div key={label} className="flex justify-between">
                    <span className="text-tradingview-text/60">{label}</span>
                    <span className={value > 0 ? 'text-green-500' : 'text-tradingview-text'}>
                      {value.toFixed(2)}
                    </span>
                  </div>
                ))}
              </div>

              <div className="mt-4 pt-4 border-t border-tradingview-border">
                <div className="flex gap-2">
                  <button className="bg-tradingview-panel border border-tradingview-border rounded px-4 py-2 text-sm text-tradingview-text hover:bg-tradingview-border">Deposit</button>
                  <button className="bg-tradingview-panel border border-tradingview-border rounded px-4 py-2 text-sm text-tradingview-text hover:bg-tradingview-border">Withdraw</button>
                  <button className="bg-tradingview-panel border border-tradingview-border rounded px-4 py-2 text-sm text-tradingview-text hover:bg-tradingview-border">Statements</button>
                </div>
              </div>
            </div>
          </div>

          {/* Main Content */}
          <div className="col-span-3">
            <div className="bg-tradingview-panel border border-tradingview-border rounded-lg p-6">
              <div className="flex justify-between items-center mb-6">
                <div>
                  <div className="text-2xl font-semibold text-tradingview-text">7,496.09</div>
                  <div className="flex items-center gap-2 text-green-500">
                    <ArrowUpIcon className="h-5 w-5" />
                    <span>7,449.03</span>
                  </div>
                </div>
                <div className="flex gap-2">
                  {(['7D', 'MTD', 'YTD', '1Y', 'All'] as const).map((timeframe) => (
                    <button
                      key={timeframe}
                      onClick={() => setSelectedTimeframe(timeframe)}
                      className={`px-3 py-1 rounded ${
                        selectedTimeframe === timeframe
                          ? 'bg-blue-500/20 text-blue-500'
                          : 'text-tradingview-text/60 hover:bg-tradingview-border'
                      }`}
                    >
                      {timeframe}
                    </button>
                  ))}
                </div>
              </div>

              {/* Chart Placeholder */}
              <div className="h-64 bg-tradingview-bg border border-tradingview-border rounded flex items-center justify-center text-tradingview-text/60">
                Chart will be implemented here
              </div>

              {/* Portfolio Positions */}
              <div className="mt-8">
                <div className="flex justify-between items-center mb-4">
                  <h2 className="text-lg font-semibold text-tradingview-text">Top Portfolio Positions</h2>
                  <button className="text-blue-500 hover:text-blue-400">↗</button>
                </div>
                {isLoading ? (
                  <div className="animate-pulse space-y-4">
                    <div className="h-8 bg-tradingview-border rounded"></div>
                    <div className="h-8 bg-tradingview-border rounded"></div>
                    <div className="h-8 bg-tradingview-border rounded"></div>
                  </div>
                ) : error ? (
                  <div className="text-red-500 p-4 bg-red-500/10 border border-red-500/20 rounded">
                    {error}
                  </div>
                ) : portfolio && portfolio.holdingList && portfolio.holdingList.length > 0 ? (
                  <>
                    <table className="w-full">
                      <thead>
                        <tr className="text-left text-tradingview-text/60">
                          <th className="py-2">SYMBOL</th>
                          <th className="py-2">POSITION</th>
                          <th className="py-2">AVG PRICE</th>
                          <th className="py-2">P&L</th>
                        </tr>
                      </thead>
                      <tbody>
                        {portfolio.holdingList.map((holding) => (
                          <tr key={holding.symbol} className="border-t border-tradingview-border">
                            <td className="py-3">
                              <button 
                                onClick={() => handleSymbolClick(holding.symbol)}
                                className="text-tradingview-text hover:text-blue-500 transition-colors"
                              >
                                {holding.symbol || '—'}
                              </button>
                            </td>
                            <td className={`text-tradingview-text ${holding.positionAmount > 0 ? 'text-green-500' : holding.positionAmount < 0 ? 'text-red-500' : ''}`}>
                              {typeof holding.positionAmount === 'number' ? holding.positionAmount.toFixed(2) : '—'}
                            </td>
                            <td className="text-tradingview-text">€ {typeof holding.positionPrice === 'number' ? holding.positionPrice.toFixed(2) : '—'}</td>
                            <td className={`text-tradingview-text ${holding.profitLoss > 0 ? 'text-green-500' : holding.profitLoss < 0 ? 'text-red-500' : ''}`}>
                              € {typeof holding.profitLoss === 'number' ? holding.profitLoss.toFixed(2) : '—'}
                            </td>
                          </tr>
                        ))}
                      </tbody>
                    </table>
                    <div className="mt-4 pt-4 border-t border-tradingview-border">
                      <div className="flex justify-between items-center">
                        <span className="text-tradingview-text/60">Total P&L:</span>
                        <span className={`text-lg font-semibold ${portfolio.totalProfitLoss > 0 ? 'text-green-500' : portfolio.totalProfitLoss < 0 ? 'text-red-500' : 'text-tradingview-text'}`}>
                          € {portfolio.totalProfitLoss.toFixed(2)}
                        </span>
                      </div>
                    </div>
                  </>
                ) : (
                  <div className="text-tradingview-text/60 p-4 text-center">
                    No portfolio positions available
                  </div>
                )}
              </div>

              {/* News Section */}
              <div className="mt-8">
                <div className="flex justify-between items-center mb-4">
                  <h2 className="text-lg font-semibold text-tradingview-text flex items-center gap-2">
                    <span>🔥</span>
                    Hot News
                  </h2>
                  <div className="flex items-center gap-4">
                    <span className="text-tradingview-text/60">From Daily Overview News</span>
                    <div className="flex items-center gap-2">
                      <button className="text-tradingview-text/60 hover:text-tradingview-text">←</button>
                      <span className="text-tradingview-text/60">1/12</span>
                      <button className="text-tradingview-text/60 hover:text-tradingview-text">→</button>
                    </div>
                  </div>
                </div>
                {news.map((item) => (
                  <div key={item.title} className="border-t border-tradingview-border py-4">
                    <div className="text-sm text-tradingview-text/60">{item.source}</div>
                    <div className="font-medium my-2 text-tradingview-text">{item.title}</div>
                    <div className="text-sm text-tradingview-text/60">
                      {item.timeAgo} • {item.readTime}
                    </div>
                  </div>
                ))}
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Dashboard; 