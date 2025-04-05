import { useState, useEffect } from 'react';
import { MagnifyingGlassIcon, ChartBarIcon, BellIcon, ArrowPathIcon } from '@heroicons/react/24/outline';
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
  onLogout: () => void;
  selectedSymbol: Stock;
  onSymbolChange: (symbol: Stock) => void;
  symbols: Stock[];
}

const Header = ({ onLogout, selectedSymbol, onSymbolChange, symbols }: HeaderProps) => {
  const [searchQuery, setSearchQuery] = useState('');
  const [searchResults, setSearchResults] = useState<Stock[]>([]);
  const [isSearching, setIsSearching] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [showSearchResults, setShowSearchResults] = useState(false);
  const [selectedStock, setSelectedStock] = useState<Stock | null>(null);

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
    setSelectedStock(stock);
    setSearchQuery(stock.symbol);
    setSearchResults([]);
    setShowSearchResults(false);
    onSymbolChange(stock);
  };

  return (
    <header className="bg-[#131722] text-white p-4">
      <div className="container mx-auto flex justify-between items-center">
        <div className="flex items-center space-x-4">
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
            {showSearchResults && searchResults.length > 0 && (
              <div className="absolute top-full left-0 mt-1 w-96 bg-[#1e222d] rounded-lg shadow-lg z-50 max-h-96 overflow-y-auto">
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
          {selectedStock && (
            <div className="flex items-center space-x-2">
              <span className="font-semibold">{selectedStock.symbol}</span>
              <span className="text-sm text-gray-400">({selectedStock.exchange})</span>
            </div>
          )}
        </div>
        <div className="flex items-center space-x-4">
          <button
            onClick={onLogout}
            className="bg-red-600 hover:bg-red-700 text-white px-4 py-2 rounded-lg transition-colors"
          >
            Logout
          </button>
        </div>
      </div>
    </header>
  );
};

export default Header; 