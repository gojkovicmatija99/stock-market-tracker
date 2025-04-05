import { authService } from './authService';

export enum TransactionType {
  BUY = 'BUY',
  SELL = 'SELL'
}

export interface Transaction {
  transactionId: string;
  type: TransactionType;
  userId: string;
  symbol: string;
  price: number;
  amount: number;
  date: string;
}

class TransactionService {
  private readonly API_URL = 'http://localhost:8083/transactions';

  async getTransactions(): Promise<Transaction[]> {
    try {
      console.log('Fetching transactions...');
      const response = await fetch(this.API_URL, {
        method: 'GET',
        headers: authService.getAuthHeaders()
      });

      console.log('Transactions response status:', response.status);
      if (!response.ok) {
        const errorText = await response.text();
        console.error('Transactions error response:', errorText);
        throw new Error(`Failed to fetch transactions: ${response.status}`);
      }

      const data = await response.json();
      console.log('Fetched transactions:', data);
      return data;
    } catch (error) {
      console.error('Error fetching transactions:', error);
      throw error;
    }
  }

  async createTransaction(
    symbol: string,
    type: TransactionType,
    amount: number,
    price: number
  ): Promise<Transaction> {
    try {
      const requestBody = {
        symbol,
        type,
        amount,
        price
      };
      console.log('Creating transaction with data:', requestBody);

      const response = await fetch(this.API_URL, {
        method: 'POST',
        headers: authService.getAuthHeaders(),
        body: JSON.stringify(requestBody)
      });

      console.log('Create transaction response status:', response.status);
      if (!response.ok) {
        const errorText = await response.text();
        console.error('Create transaction error response:', errorText);
        throw new Error(`Failed to create transaction: ${response.status}`);
      }

      const data = await response.json();
      console.log('Created transaction:', data);
      return data;
    } catch (error) {
      console.error('Error creating transaction:', error);
      throw error;
    }
  }
}

export const transactionService = new TransactionService(); 