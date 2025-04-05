import { useEffect, useState } from 'react';
import { ArrowPathIcon } from '@heroicons/react/24/outline';
import { transactionService, Transaction, TransactionType } from '../services/transactionService';

interface TransactionsProps {
  symbol: string;
  currentPrice: number;
}

const Transactions = ({ symbol, currentPrice }: TransactionsProps) => {
  const [transactions, setTransactions] = useState<Transaction[]>([]);
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [amount, setAmount] = useState<string>('1');

  const loadTransactions = async () => {
    setIsLoading(true);
    setError(null);
    try {
      console.log('Loading transactions for symbol:', symbol);
      const data = await transactionService.getTransactionsBySymbol(symbol);
      setTransactions(data);
    } catch (err) {
      console.error('Error in loadTransactions:', err);
      setError('Failed to load transactions');
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    loadTransactions();
  }, [symbol]);

  const handleTransaction = async (type: TransactionType) => {
    try {
      console.log('Handling transaction:', { type, symbol, amount, currentPrice });
      const numAmount = parseFloat(amount);
      if (isNaN(numAmount) || numAmount <= 0) {
        setError('Please enter a valid amount');
        return;
      }

      await transactionService.createTransaction(symbol, type, numAmount, currentPrice);
      await loadTransactions();
      setAmount('1');
      setError(null);
    } catch (err) {
      console.error('Error in handleTransaction:', err);
      setError('Failed to create transaction');
    }
  };

  const formatDate = (dateString: string) => {
    return new Date(dateString).toLocaleString();
  };

  return (
    <div className="p-4 bg-tradingview-panel border-t border-tradingview-border">
      <div className="flex items-center justify-between mb-4">
        <h2 className="text-lg font-medium text-tradingview-text">Transactions</h2>
        <button
          onClick={loadTransactions}
          className="p-2 hover:bg-tradingview-bg rounded"
        >
          <ArrowPathIcon className="h-4 w-4 text-tradingview-text" />
        </button>
      </div>

      {error && (
        <div className="mb-4 p-2 bg-red-500/10 border border-red-500/20 rounded">
          <p className="text-red-500 text-sm">{error}</p>
        </div>
      )}

      <div className="flex items-center space-x-4 mb-4">
        <div className="flex flex-col">
          <label htmlFor="amount" className="text-sm text-tradingview-text opacity-60 mb-1">
            Amount
          </label>
          <input
            id="amount"
            type="number"
            value={amount}
            onChange={(e) => setAmount(e.target.value)}
            min="1"
            step="1"
            className="bg-tradingview-bg text-tradingview-text border border-tradingview-border rounded px-2 py-1 w-24"
          />
        </div>
        <div className="flex space-x-2">
          <button
            onClick={() => handleTransaction(TransactionType.BUY)}
            className="px-4 py-2 bg-green-500 text-white rounded hover:bg-green-600 transition-colors"
          >
            Buy
          </button>
          <button
            onClick={() => handleTransaction(TransactionType.SELL)}
            className="px-4 py-2 bg-red-500 text-white rounded hover:bg-red-600 transition-colors"
          >
            Sell
          </button>
        </div>
      </div>

      {isLoading ? (
        <div className="flex items-center justify-center space-x-2 text-tradingview-text">
          <ArrowPathIcon className="h-4 w-4 animate-spin" />
          <span>Loading transactions...</span>
        </div>
      ) : (
        <div className="space-y-2 max-h-[400px] overflow-y-auto pr-2">
          {transactions.map((transaction) => (
            <div
              key={transaction.transactionId}
              className="flex items-center justify-between p-2 bg-tradingview-bg rounded"
            >
              <div className="flex items-center space-x-4">
                <div className={`px-2 py-1 rounded text-sm ${
                  transaction.type === TransactionType.BUY
                    ? 'bg-green-500/20 text-green-500'
                    : 'bg-red-500/20 text-red-500'
                }`}>
                  {transaction.type}
                </div>
                <div className="text-tradingview-text">
                  {transaction.amount} {transaction.symbol}
                </div>
              </div>
              <div className="text-right">
                <div className="text-tradingview-text">
                  ${transaction.price.toFixed(2)}
                </div>
                <div className="text-sm text-tradingview-text opacity-60">
                  {formatDate(transaction.date)}
                </div>
              </div>
            </div>
          ))}
          {transactions.length === 0 && (
            <div className="text-center text-tradingview-text opacity-60 py-4">
              No transactions yet
            </div>
          )}
        </div>
      )}
    </div>
  );
};

export default Transactions; 