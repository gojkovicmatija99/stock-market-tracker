import { authService } from './authService';

export interface StockOverview {
  symbol: string;
  name: string;
  price: number;
  change: number;
  changePercent: number;
  marketCap: number;
  volume: number;
  peRatio: number;
  dividendYield: number;
  description: string;
}

class StockInfoService {
  private baseUrl: string;
  private apiKey: string;

  constructor() {
    this.baseUrl = 'http://localhost:8081';
    this.apiKey = 'demo'; // In production, this should be stored securely
  }

  async getStockOverview(symbol: string): Promise<StockOverview> {
    try {
      const response = await fetch(
        `${this.baseUrl}/market/overview/${symbol}`,
        { headers: authService.getAuthHeaders() }
      );
      
      if (!response.ok) {
        throw new Error('Failed to fetch stock overview');
      }

      const data = await response.json();
      if (data.status !== 'ok') {
        throw new Error(data.message || 'Invalid response format');
      }

      return {
        symbol: data.meta.symbol,
        name: data.meta.name || '',
        price: parseFloat(data.overview.price),
        change: parseFloat(data.overview.change),
        changePercent: parseFloat(data.overview.changePercent),
        marketCap: parseFloat(data.overview.marketCap),
        volume: parseFloat(data.overview.volume),
        peRatio: parseFloat(data.overview.peRatio),
        dividendYield: parseFloat(data.overview.dividendYield),
        description: data.overview.description || ''
      };
    } catch (error) {
      console.error('Error fetching stock overview:', error);
      throw error;
    }
  }
}

export const stockInfoService = new StockInfoService(); 