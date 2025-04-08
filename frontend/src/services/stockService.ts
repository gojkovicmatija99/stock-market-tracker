import { authService } from './authService';

interface StockData {
  price: number;
}

interface StockInfo {
  symbol: string;
  name: string;
  exchange: string;
  mic_code: string;
  country: string;
  type: string;
}

interface StockSearchResult {
  symbol: string;
  name: string;
  exchange: string;
  mic_code: string;
  country: string;
  type: string;
}

const BACKEND_URL = 'http://localhost:8082';

class StockService {
  async getStockData(symbol: string): Promise<StockData> {
    try {
      const token = authService.getToken();
      if (!token) {
        throw new Error('No authentication token available');
      }

      const response = await fetch(`http://localhost:8082/market/stocks/${symbol}`, {
        headers: {
          'Authorization': `Bearer ${token}`,
          'Content-Type': 'application/json',
        },
      });

      if (response.status === 401) {
        authService.logout();
        throw new Error('Authentication failed');
      }

      if (!response.ok) {
        throw new Error('Failed to fetch stock data');
      }

      const data = await response.json();
      return {
        price: data.price
      };
    } catch (error) {
      console.error('Error fetching stock data:', error);
      throw error;
    }
  }

  async searchStocks(query: string): Promise<StockSearchResult[]> {
    try {
      const token = authService.getToken();
      if (!token) {
        throw new Error('No authentication token available');
      }

      const response = await fetch(`${BACKEND_URL}/market/stocks/${encodeURIComponent(query)}`, {
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${token}`
        }
      });

      if (!response.ok) {
        throw new Error('Failed to search stocks');
      }

      const data = await response.json();
      return data;
    } catch (error) {
      console.error('Error searching stocks:', error);
      throw error;
    }
  }

  async getStockInfo(symbol: string): Promise<StockInfo> {
    try {
      const token = authService.getToken();
      if (!token) {
        throw new Error('No authentication token available');
      }

      const response = await fetch(`http://localhost:8082/market/stocks/${symbol}`, {
        headers: {
          'Authorization': `Bearer ${token}`,
          'Content-Type': 'application/json',
        },
      });

      if (response.status === 401) {
        authService.logout();
        throw new Error('Authentication failed');
      }

      if (!response.ok) {
        throw new Error('Failed to fetch stock info');
      }

      const data = await response.json();
      return data;
    } catch (error) {
      console.error('Error fetching stock info:', error);
      throw error;
    }
  }

  async getCurrentPrice(symbol: string): Promise<number> {
    try {
      const token = authService.getToken();
      if (!token) {
        throw new Error('No authentication token available');
      }

      const response = await fetch(`${BACKEND_URL}/market/prices/${symbol}`, {
        headers: {
          'Authorization': `Bearer ${token}`
        }
      });

      if (!response.ok) {
        throw new Error('Failed to fetch current price');
      }

      const data = await response.json();
      return data.price;
    } catch (error) {
      console.error('Error fetching current price:', error);
      throw error;
    }
  }
}

export const stockService = new StockService(); 