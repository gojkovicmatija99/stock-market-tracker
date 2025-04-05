import { authService } from './authService';
import { TimeInterval } from '../components/Watchlist';

export interface MarketData {
  datetime: string;
  open: string;
  high: string;
  low: string;
  close: string;
  volume: string;
}

export interface SymbolMetadata {
  symbol: string;
  name: string | null;
  exchange: string;
  mic_code: string;
  country: string | null;
  type: string;
}

export interface MarketDataResponse {
  code: number;
  message: string | null;
  status: string;
  meta: SymbolMetadata;
  values: MarketData[];
}

export interface SymbolData {
  symbol: string;
  price: string;
  change: string;
  changePercent: string;
  exchange: string;
}

class MarketDataService {
  private baseUrl: string;

  constructor() {
    this.baseUrl = 'http://localhost:8082';
  }

  async getHistoricalData(symbol: string, interval: TimeInterval): Promise<MarketData[]> {
    try {
      const response = await fetch(
        `${this.baseUrl}/market/time-series/${symbol}?interval=${interval}`,
        { headers: authService.getAuthHeaders() }
      );
      
      if (!response.ok) {
        throw new Error('Failed to fetch historical data');
      }
      const data: MarketDataResponse = await response.json();
      if (data.status !== 'ok' || !data.values) {
        throw new Error(data.message || 'Invalid response format');
      }
      // Sort values by datetime in ascending order
      return data.values.sort((a, b) => new Date(a.datetime).getTime() - new Date(b.datetime).getTime());
    } catch (error) {
      console.error('Error fetching historical data:', error);
      throw error;
    }
  }

  async getWatchlistData(symbols: string[], interval: TimeInterval): Promise<SymbolData[]> {
    try {
      // Fetch data for each symbol in parallel
      const promises = symbols.map(symbol => 
        fetch(
          `${this.baseUrl}/market/time-series/${symbol}?interval=${interval}`,
          { headers: authService.getAuthHeaders() }
        ).then(res => res.json())
      );
      
      const responses = await Promise.all(promises);
      
      return responses.map((data: MarketDataResponse) => {
        const latestValue = data.values[0];
        const previousValue = data.values[1];
        
        const change = (parseFloat(latestValue.close) - parseFloat(previousValue.close)).toFixed(2);
        const changePercent = ((parseFloat(latestValue.close) - parseFloat(previousValue.close)) / 
          parseFloat(previousValue.close) * 100).toFixed(2);
        
        return {
          symbol: data.meta.symbol,
          price: latestValue.close,
          change,
          changePercent,
          exchange: data.meta.exchange
        };
      });
    } catch (error) {
      console.error('Error fetching watchlist data:', error);
      throw error;
    }
  }

  async refreshSymbolData(symbol: string, interval: TimeInterval): Promise<SymbolData> {
    try {
      const response = await fetch(
        `${this.baseUrl}/market/time-series/${symbol}?interval=${interval}`,
        { headers: authService.getAuthHeaders() }
      );
      
      if (!response.ok) {
        throw new Error('Failed to fetch symbol data');
      }

      const data: MarketDataResponse = await response.json();
      if (data.status !== 'ok' || !data.values || data.values.length < 2) {
        throw new Error(data.message || 'Invalid response format');
      }

      const latestValue = data.values[0];
      const previousValue = data.values[1];
      
      const change = (parseFloat(latestValue.close) - parseFloat(previousValue.close)).toFixed(2);
      const changePercent = ((parseFloat(latestValue.close) - parseFloat(previousValue.close)) / 
        parseFloat(previousValue.close) * 100).toFixed(2);
      
      return {
        symbol: data.meta.symbol,
        price: latestValue.close,
        change,
        changePercent,
        exchange: data.meta.exchange
      };
    } catch (error) {
      console.error('Error refreshing symbol data:', error);
      throw error;
    }
  }

  async subscribeToRealtimeData(symbol: string, callback: (data: MarketData) => void): Promise<WebSocket> {
    const token = authService.getToken();
    const ws = new WebSocket(`ws://localhost:8081/ws/market/${symbol}?token=${token}`);
    
    ws.onmessage = (event) => {
      const data = JSON.parse(event.data);
      if (data.status === 'ok' && data.values && data.values.length > 0) {
        callback(data.values[0]);
      }
    };

    ws.onerror = (error) => {
      console.error('WebSocket error:', error);
    };

    return ws;
  }
}

export const marketDataService = new MarketDataService(); 