import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { ArrowUpIcon, ClipboardIcon } from '@heroicons/react/24/solid';
import { authService } from '../services/authService';
import Header from './Header';
import { Line } from 'react-chartjs-2';
import {
  Chart as ChartJS,
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  Title,
  Tooltip,
  Legend,
  ChartOptions
} from 'chart.js';
import { StockWebSocketClient } from '../services/StockWebSocketClient';

// Register ChartJS components
ChartJS.register(
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  Title,
  Tooltip,
  Legend
);

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

interface PortfolioHistoryItem {
  datetime: string;
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

interface PriceUpdate {
  symbol: string;
  price: number;
  timestamp: string;
}

const Dashboard = () => {
  const navigate = useNavigate();
  const [selectedTab, setSelectedTab] = useState<'Dashboard' | 'Positions' | 'Performance' | 'Balances' | 'Portfolio News'>('Dashboard');
  const [selectedInterval, setSelectedInterval] = useState<string>('15min');
  const [portfolio, setPortfolio] = useState<Portfolio | null>(null);
  const [portfolioHistory, setPortfolioHistory] = useState<PortfolioHistoryItem[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [isHistoryLoading, setIsHistoryLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [selectedSymbol, setSelectedSymbol] = useState<string>('AAPL');
  const [symbols, setSymbols] = useState<Stock[]>([]);
  const [livePrices, setLivePrices] = useState<Record<string, number>>({});
  const [wsClient] = useState(() => new StockWebSocketClient());
  const [isConnected, setIsConnected] = useState(false);
  const [priceUpdates, setPriceUpdates] = useState<Record<string, PriceUpdate>>({});

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
    navigate('/login');
  };

  // Set up WebSocket connection
  useEffect(() => {
    const setupWebSocket = async () => {
      try {
        const websocket = new WebSocket('ws://localhost:8082/ws/stock');
        
        websocket.onopen = () => {
          setIsConnected(true);
          
          // Subscribe to portfolio symbols when connected
          if (portfolio?.holdingList) {
            portfolio.holdingList.forEach(holding => {
              websocket.send(holding.symbol);
            });
          }
        };

        websocket.onmessage = (event) => {
          try {
            const data = JSON.parse(event.data);
            
            // Update price data for display
            setPriceUpdates(prev => ({
              ...prev,
              [data.symbol]: {
                symbol: data.symbol,
                price: data.price,
                timestamp: new Date().toISOString()
              }
            }));

            // Update live prices
            setLivePrices(prev => ({
              ...prev,
              [data.symbol]: data.price
            }));
          } catch (error) {
            console.error('Error parsing WebSocket message:', error);
          }
        };

        websocket.onerror = (error) => {
          console.error('WebSocket error:', error);
        };

        websocket.onclose = () => {
          setIsConnected(false);
        };

        // Store WebSocket instance
        wsClient.setWebSocket(websocket);
      } catch (error) {
        console.error('Error connecting to WebSocket:', error);
      }
    };

    setupWebSocket();

    // Cleanup on unmount
    return () => {
      if (wsClient) {
        wsClient.disconnect();
      }
    };
  }, [wsClient, portfolio]);

  // Fetch initial symbols
  useEffect(() => {
    const fetchSymbols = async () => {
      try {
        const token = authService.getToken();
        if (!token) {
          authService.logout();
          return;
        }

        const response = await fetch('http://localhost:8082/market/stocks', {
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

  // Fetch portfolio data
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

  // Fetch portfolio history data
  useEffect(() => {
    const fetchPortfolioHistory = async () => {
      setIsHistoryLoading(true);
      try {
        const token = authService.getToken();
        if (!token) {
          authService.logout();
          return;
        }

        const response = await fetch(`http://localhost:8083/portfolio/history?interval=${selectedInterval}`, {
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
          throw new Error('Failed to fetch portfolio history');
        }

        const data = await response.json();
        setPortfolioHistory(data);
      } catch (err) {
        console.error('Failed to fetch portfolio history:', err);
      } finally {
        setIsHistoryLoading(false);
      }
    };

    fetchPortfolioHistory();
  }, [selectedInterval]);

  const handleSymbolClick = (symbol: string) => {
    navigate(`/stock/${symbol}`);
  };

  // Prepare chart data
  const chartData = {
    labels: portfolioHistory.map(item => {
      const date = new Date(item.datetime);
      
      // Format the date based on the selected interval
      if (selectedInterval === '1day' || selectedInterval === '1week' || selectedInterval === '1month') {
        // For longer intervals, show date
        return date.toLocaleDateString([], { month: 'short', day: 'numeric' });
      } else {
        // For shorter intervals, show time
        return date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
      }
    }).reverse(),
    datasets: [
      {
        label: 'Portfolio Value',
        data: portfolioHistory.map(item => item.totalProfitLoss).reverse(),
        borderColor: 'rgb(75, 192, 192)',
        backgroundColor: 'rgba(75, 192, 192, 0.5)',
        tension: 0.1,
      },
    ],
  };

  const chartOptions: ChartOptions<'line'> = {
    responsive: true,
    maintainAspectRatio: false,
    plugins: {
      legend: {
        position: 'top' as const,
        labels: {
          color: 'rgba(255, 255, 255, 0.7)',
        },
      },
      tooltip: {
        mode: 'index',
        intersect: false,
        callbacks: {
          title: (tooltipItems) => {
            const index = tooltipItems[0].dataIndex;
            const item = portfolioHistory[portfolioHistory.length - 1 - index];
            const date = new Date(item.datetime);
            return date.toLocaleString([], { 
              month: 'short', 
              day: 'numeric', 
              hour: '2-digit', 
              minute: '2-digit' 
            });
          },
          label: (context) => {
            const index = context.dataIndex;
            const item = portfolioHistory[portfolioHistory.length - 1 - index];
            return `Portfolio Value: €${item.totalProfitLoss.toFixed(2)}`;
          }
        }
      },
    },
    scales: {
      x: {
        grid: {
          color: 'rgba(255, 255, 255, 0.1)',
        },
        ticks: {
          color: 'rgba(255, 255, 255, 0.7)',
        },
      },
      y: {
        grid: {
          color: 'rgba(255, 255, 255, 0.1)',
        },
        ticks: {
          color: 'rgba(255, 255, 255, 0.7)',
          callback: (value) => `€${value}`
        },
      },
    },
  };

  return (
    <div className="min-h-screen bg-tradingview-bg">
      <Header 
        selectedSymbol={selectedSymbol}
        onSymbolChange={(symbol) => navigate(`/stock/${symbol}`)}
        symbols={symbols}
        onLogout={handleLogout}
      />
      
      <div className="container mx-auto">
        <div className="p-6">
          <div className="grid grid-cols-1 gap-6">
            {/* Main Content */}
            <div className="col-span-1">
              <div className="bg-tradingview-panel border border-tradingview-border rounded-lg p-6">
                {/* Portfolio Value */}
                <div className="flex justify-between items-center mb-6">
                  <div>
                    <div className="text-2xl font-semibold text-tradingview-text">
                      €{portfolio?.totalProfitLoss.toFixed(2) || '0.00'}
                    </div>
                    <div className="flex items-center gap-1 text-green-500">
                      <ArrowUpIcon className="h-4 w-4" />
                      <span>Total P&L</span>
                    </div>
                  </div>
                </div>

                {/* Chart Area */}
                <div className="mb-4">
                  <div className="flex flex-wrap gap-2 mb-2">
                    {['1min', '5min', '15min', '30min', '45min', '1h', '2h', '4h', '1day', '1week', '1month'].map((interval) => (
                      <button
                        key={interval}
                        onClick={() => setSelectedInterval(interval)}
                        className={`px-2 py-1 text-xs rounded ${
                          selectedInterval === interval
                            ? 'bg-blue-500/20 text-blue-500'
                            : 'text-tradingview-text/60 hover:bg-tradingview-border'
                        }`}
                      >
                        {interval}
                      </button>
                    ))}
                  </div>
                  <div className="h-64 bg-tradingview-bg border border-tradingview-border rounded-lg">
                    {isHistoryLoading ? (
                      <div className="h-full flex items-center justify-center text-tradingview-text/60">
                        Loading chart data...
                      </div>
                    ) : portfolioHistory.length > 0 ? (
                      <Line data={chartData} options={chartOptions} />
                    ) : (
                      <div className="h-full flex items-center justify-center text-tradingview-text/60">
                        No chart data available
                      </div>
                    )}
                  </div>
                </div>

                {/* Portfolio Positions */}
                <div className="mb-8">
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
                    <div className="text-red-500 p-4 bg-red-500/10 border border-red-500/20 rounded-lg">
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
                          <span className={`text-lg font-semibold ${
                            portfolio.totalProfitLoss > 0 ? 'text-green-500' : 
                            portfolio.totalProfitLoss < 0 ? 'text-red-500' : 
                            'text-tradingview-text'
                          }`}>
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

                {/* Price Updates Display */}
                <div className="mb-8">
                  <h2 className="text-2xl font-bold mb-4 text-tradingview-text">Live Price Updates</h2>
                  <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                    {Object.entries(priceUpdates).map(([symbol, update]) => (
                      <div key={symbol} className="border rounded p-4 bg-tradingview-bg border-tradingview-border">
                        <h3 className="font-bold text-lg text-tradingview-text">{symbol}</h3>
                        <p className="text-xl text-tradingview-text">${update.price.toFixed(2)}</p>
                        <p className="text-sm text-tradingview-text/60">
                          Last update: {new Date(update.timestamp).toLocaleTimeString()}
                        </p>
                      </div>
                    ))}
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Dashboard;