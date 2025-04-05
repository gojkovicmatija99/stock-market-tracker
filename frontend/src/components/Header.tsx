import { useState, useEffect } from 'react';
import { MagnifyingGlassIcon } from '@heroicons/react/24/outline';
import { stockService } from '../services/stockService';

interface Stock {
  symbol: string;
  name: string;
  exchange: string;
  mic_code: string;
  country: string;
  type: string;
}

interface HeaderProps {
  selectedSymbol: string;
  onSymbolChange: (symbol: string) => void;
  symbols: Stock[];
  onLogout: () => void;
}

const Header = ({ selectedSymbol, onSymbolChange, symbols, onLogout }: HeaderProps) => {
  const [searchQuery, setSearchQuery] = useState('');
  const [searchResults, setSearchResults] = useState<Stock[]>([]);
  const [isSearching, setIsSearching] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [showSearchResults, setShowSearchResults] = useState(false);

  const handleSearch = async (query: string) => {
    setIsSearching(true);
    setError(null);
    try {
      const results = await stockService.searchStocks(query);
      setSearchResults(results);
    } catch (err) {
      setError('Failed to search stocks');
      console.error('Search error:', err);
    } finally {
      setIsSearching(false);
    }
  };

  useEffect(() => {
    const timeoutId = setTimeout(() => {
      if (searchQuery.length >= 2) {
        handleSearch(searchQuery);
      }
    }, 300);

    return () => clearTimeout(timeoutId);
  }, [searchQuery]);

  const handleStockSelect = (stock: Stock) => {
    setSearchQuery(stock.symbol);
    setSearchResults([]);
    setShowSearchResults(false);
    onSymbolChange(stock.symbol);
  };

  return (
    <div className="bg-tradingview-bg border-b border-tradingview-border">
      <div className="container mx-auto px-4 py-4">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-6">
            <h1 className="text-2xl font-bold text-tradingview-text">Stock Market Tracker</h1>
            <div className="text-xl text-tradingview-text/90">
              {selectedSymbol}
            </div>
          </div>
          <div className="relative">
            <div className="relative">
              <input
                type="text"
                placeholder="Search stocks..."
                value={searchQuery}
                onChange={(e) => {
                  setSearchQuery(e.target.value);
                  if (e.target.value.length >= 2) {
                    handleSearch(e.target.value);
                  } else {
                    setSearchResults([]);
                  }
                }}
                onFocus={() => setShowSearchResults(true)}
                className="bg-[#1e222d] text-white px-4 py-2 rounded-lg w-80 focus:outline-none focus:ring-2 focus:ring-blue-500"
              />
              <MagnifyingGlassIcon className="absolute right-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" />
            </div>
            {showSearchResults && searchResults.length > 0 && (
              <div className="absolute top-full right-0 mt-1 w-96 bg-[#1e222d] rounded-lg shadow-lg z-50 max-h-96 overflow-y-auto">
                {searchResults.map((stock) => (
                  <button
                    key={`${stock.symbol}-${stock.mic_code}`}
                    onClick={() => handleStockSelect(stock)}
                    className="w-full text-left px-4 py-2 hover:bg-[#2a2e39] flex justify-between items-center border-b border-[#2a2e39]"
                  >
                    <div>
                      <div className="font-semibold">{stock.symbol}</div>
                      <div className="text-sm text-gray-400">{stock.name}</div>
                    </div>
                    <div className="text-right">
                      <div className="text-sm">{stock.exchange}</div>
                      <div className="text-xs text-gray-400">{stock.country}</div>
                    </div>
                  </button>
                ))}
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  );
};

export default Header; 