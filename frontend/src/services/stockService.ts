import { authService } from './authService';

const API_KEY = 'YOUR_ALPHA_VANTAGE_API_KEY'; // Replace with your API key
const BASE_URL = 'https://www.alphavantage.co/query';
const BACKEND_URL = 'http://localhost:8082';

interface StockData {
  price: number;
}

interface StockSearchResult {
  symbol: string;
  name: string;
  exchange: string;
  mic_code: string;
  country: string;
  type: string;
}

class StockService {
  async getStockData(symbol: string): Promise<StockData> {
    try {
      const token = authService.getToken();
      if (!token) {
        throw new Error('No authentication token available');
      }

      // First try our backend
      try {
        const response = await fetch(`${BACKEND_URL}/market/stocks/${symbol}`, {
          headers: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${token}`
          }
        });

        if (response.ok) {
          const data = await response.json();
          return {
            price: data.price
          };
        }
      } catch (error) {
        console.log('Backend fetch failed, falling back to Alpha Vantage');
      }

      // Fallback to Alpha Vantage
      const response = await fetch(
        `${BASE_URL}?function=GLOBAL_QUOTE&symbol=${symbol}&apikey=${API_KEY}`
      );

      if (!response.ok) {
        throw new Error('Failed to fetch stock data');
      }

      const data = await response.json();
      const quote = data['Global Quote'];
      
      return {
        price: parseFloat(quote['05. price'])
      };
    } catch (error) {
      console.error('Error fetching stock data:', error);
      throw error;
    }
  }

  async searchStocks(symbol: string): Promise<StockSearchResult[]> {
    try {
      const token = authService.getToken();
      if (!token) {
        throw new Error('No authentication token available');
      }

      // First try our backend
      try {
        const response = await fetch(`${BACKEND_URL}/market/stocks/${symbol}`, {
          headers: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${token}`
          }
        });

        if (response.ok) {
          const data = await response.json();
          return data;
        }
      } catch (error) {
        console.log('Backend search failed, falling back to Alpha Vantage');
      }

      // Fallback to Alpha Vantage
      const response = await fetch(
        `${BASE_URL}?function=SYMBOL_SEARCH&keywords=${symbol}&apikey=${API_KEY}`
      );

      if (!response.ok) {
        throw new Error('Failed to search stocks');
      }

      const data = await response.json();
      const matches = data.bestMatches || [];

      return matches.map((match: any) => ({
        symbol: match['1. symbol'],
        name: match['2. name'],
        exchange: match['4. region'],
        mic_code: match['3. type'],
        country: match['4. region'],
        type: match['3. type']
      }));
    } catch (error) {
      console.error('Error searching stocks:', error);
      throw error;
    }
  }
}

export const stockService = new StockService(); 