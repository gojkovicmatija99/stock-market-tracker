import { useEffect, useState } from 'react';
import { StockWebSocketClient } from '../services/StockWebSocketClient';

interface Holding {
  symbol: string;
  positionAmount: number;
  positionPrice: number;
  profitLoss: number;
}

interface Portfolio {
  datetime: string;
  holdingList: Holding[];
  totalProfitLoss: number;
}

interface PortfolioLivePricesProps {
  portfolio: Portfolio;
  onPriceUpdate: (symbol: string, price: number) => void;
}

const PortfolioLivePrices = ({ portfolio, onPriceUpdate }: PortfolioLivePricesProps) => {
  const [wsClient] = useState(() => new StockWebSocketClient());
  const [connected, setConnected] = useState(false);

  useEffect(() => {
    const setupWebSocket = async () => {
      try {
        await wsClient.connect();
      } catch (error) {
        console.error('Error connecting to WebSocket:', error);
      }
    };

    setupWebSocket();

    // Subscribe to connection status changes
    wsClient.onConnectionChange(setConnected);

    // Subscribe to price updates for all portfolio holdings
    portfolio.holdingList.forEach(holding => {
      wsClient.subscribe(holding.symbol);
    });

    // Handle price updates
    wsClient.onPriceUpdate((symbol: string, price: number) => {
      onPriceUpdate(symbol, price);
    });

    // Cleanup on unmount
    return () => {
      portfolio.holdingList.forEach(holding => {
        wsClient.unsubscribe(holding.symbol);
      });
      wsClient.disconnect();
    };
  }, [portfolio, wsClient, onPriceUpdate]);

  return (
    <div className="space-y-3">
      {portfolio.holdingList.map(holding => (
        <div key={holding.symbol} className="flex justify-between items-center">
          <span className="text-tradingview-text/80">{holding.symbol}:</span>
          <span className="text-tradingview-text">
            {connected ? 'Live' : 'Offline'}
          </span>
        </div>
      ))}
    </div>
  );
};

export default PortfolioLivePrices; 