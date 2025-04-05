import { useState } from 'react';
import Chart from './components/Chart';
import Header from './components/Header';
import Toolbar from './components/Toolbar';
import StockInfo from './components/StockInfo';
import Transactions from './components/Transactions';
import { TimeInterval } from './components/Watchlist';
import Login from './components/Login';

const SYMBOLS = [
  { symbol: 'AAPL', name: 'Apple Inc.' },
  { symbol: 'AMZN', name: 'Amazon.com Inc.' },
  { symbol: 'TSLA', name: 'Tesla Inc.' },
  { symbol: 'SAP', name: 'SAP SE' },
  { symbol: 'MSFT', name: 'Microsoft Corporation' },
  { symbol: 'GOOGL', name: 'Alphabet Inc.' },
  { symbol: 'META', name: 'Meta Platforms Inc.' },
  { symbol: 'NVDA', name: 'NVIDIA Corporation' },
  { symbol: 'JPM', name: 'JPMorgan Chase & Co.' },
  { symbol: 'V', name: 'Visa Inc.' }
];

const App = () => {
  const [selectedSymbol, setSelectedSymbol] = useState(SYMBOLS[0]);
  const [selectedInterval, setSelectedInterval] = useState<TimeInterval>('15min');
  const [isLoading, setIsLoading] = useState(false);
  const [currentPrice, setCurrentPrice] = useState<number>(0);
  const [isAuthenticated, setIsAuthenticated] = useState(true);

  const handleLogout = () => {
    // Clear any stored data
    localStorage.removeItem('token');
    localStorage.removeItem('user');
    setIsAuthenticated(false);
  };

  const handleLoginSuccess = () => {
    setIsAuthenticated(true);
  };

  if (!isAuthenticated) {
    return <Login onLoginSuccess={handleLoginSuccess} />;
  }

  return (
    <div className="min-h-screen bg-tradingview-bg text-tradingview-text">
      <Header 
        selectedSymbol={selectedSymbol}
        onSymbolChange={setSelectedSymbol}
        symbols={SYMBOLS}
        onLogout={handleLogout}
      />
      <div className="container mx-auto px-4 py-8">
        <div className="grid grid-cols-1 gap-4">
          <div className="bg-tradingview-panel rounded-lg shadow-lg">
            <Toolbar
              onIntervalChange={setSelectedInterval}
              selectedInterval={selectedInterval}
              isLoading={isLoading}
            />
            <Chart
              symbol={selectedSymbol.symbol}
              interval={selectedInterval}
              onLoadingChange={setIsLoading}
            />
          </div>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <StockInfo 
              symbol={selectedSymbol.symbol} 
              onPriceUpdate={setCurrentPrice}
            />
            <Transactions 
              symbol={selectedSymbol.symbol} 
              currentPrice={currentPrice}
            />
          </div>
        </div>
      </div>
    </div>
  );
};

export default App;
