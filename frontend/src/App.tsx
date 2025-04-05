import { useState } from 'react';
import Chart from './components/Chart';
import Transactions from './components/Transactions';
import Portfolio from './components/Portfolio';
import Header from './components/Header';
import { TimeInterval } from './components/Watchlist';
import Login from './components/Login';

const SYMBOLS = [
  { symbol: 'AAPL', name: 'Apple Inc.', exchange: 'NASDAQ', mic_code: 'XNAS', country: 'US', type: 'Common Stock' },
  { symbol: 'GOOGL', name: 'Alphabet Inc.', exchange: 'NASDAQ', mic_code: 'XNAS', country: 'US', type: 'Common Stock' },
  { symbol: 'MSFT', name: 'Microsoft Corporation', exchange: 'NASDAQ', mic_code: 'XNAS', country: 'US', type: 'Common Stock' },
];

function App() {
  const [symbol, setSymbol] = useState('AAPL');
  const [interval, setInterval] = useState<TimeInterval>('15min');
  const [isLoading, setIsLoading] = useState(false);
  const [currentPrice, setCurrentPrice] = useState(0);
  const [isAuthenticated, setIsAuthenticated] = useState(true);

  const handleSymbolChange = (newSymbol: string) => {
    setSymbol(newSymbol);
  };

  const handleLogout = () => {
    setIsAuthenticated(false);
  };

  if (!isAuthenticated) {
    return <Login onLoginSuccess={() => setIsAuthenticated(true)} />;
  }

  return (
    <div className="min-h-screen bg-tradingview-bg">
      <Header 
        selectedSymbol={symbol}
        onSymbolChange={handleSymbolChange}
        symbols={SYMBOLS}
        onLogout={handleLogout}
      />
      <div className="container mx-auto px-4 py-6">
        <div className="grid grid-cols-1 lg:grid-cols-4 gap-6">
          <div className="lg:col-span-3">
            <Chart 
              symbol={symbol} 
              interval={interval} 
              onLoadingChange={setIsLoading}
              onSymbolChange={handleSymbolChange}
            />
          </div>
          <div className="lg:col-span-1 space-y-6">
            <Portfolio symbol={symbol} />
            <Transactions 
              symbol={symbol} 
              currentPrice={currentPrice}
            />
          </div>
        </div>
      </div>
    </div>
  );
}

export default App;
