import { useState, useEffect } from 'react';

interface PriceUpdate {
    symbol: string;
    price: number;
    timestamp: string;
}

const WebSocketTest = () => {
    const [messages, setMessages] = useState<string[]>([]);
    const [symbols, setSymbols] = useState<string>('AAPL,AMZN');
    const [ws, setWs] = useState<WebSocket | null>(null);
    const [isConnected, setIsConnected] = useState(false);
    const [priceUpdates, setPriceUpdates] = useState<Record<string, PriceUpdate>>({});

    useEffect(() => {
        // Cleanup on component unmount
        return () => {
            if (ws) {
                ws.close();
            }
        };
    }, [ws]);

    const connectWebSocket = () => {
        const websocket = new WebSocket('ws://localhost:8082/ws/stock');

        websocket.onopen = () => {
            setIsConnected(true);
            setMessages(prev => [...prev, 'Connected to WebSocket']);
            // Subscribe to all symbols
            const symbolList = symbols.split(',').map(s => s.trim());
            symbolList.forEach(symbol => {
                websocket.send(symbol);
                setMessages(prev => [...prev, `Subscribed to ${symbol}`]);
            });
        };

        websocket.onmessage = (event) => {
            try {
                const data = JSON.parse(event.data);
                setMessages(prev => [...prev, `Received: ${event.data}`]);
                
                // Update price data
                setPriceUpdates(prev => ({
                    ...prev,
                    [data.symbol]: {
                        symbol: data.symbol,
                        price: data.price,
                        timestamp: new Date().toISOString()
                    }
                }));
            } catch (error) {
                setMessages(prev => [...prev, `Error parsing message: ${event.data}`]);
            }
        };

        websocket.onerror = (error) => {
            setMessages(prev => [...prev, `Error: ${error}`]);
        };

        websocket.onclose = () => {
            setIsConnected(false);
            setMessages(prev => [...prev, 'Disconnected from WebSocket']);
        };

        setWs(websocket);
    };

    const disconnectWebSocket = () => {
        if (ws) {
            ws.close();
            setWs(null);
        }
    };

    const changeSymbols = () => {
        if (ws && ws.readyState === WebSocket.OPEN) {
            // Clear existing subscriptions
            setPriceUpdates({});
            setMessages(prev => [...prev, 'Clearing existing subscriptions']);
            
            // Subscribe to new symbols
            const symbolList = symbols.split(',').map(s => s.trim());
            symbolList.forEach(symbol => {
                ws.send(symbol);
                setMessages(prev => [...prev, `Subscribed to ${symbol}`]);
            });
        }
    };

    return (
        <div className="p-4">
            <h2 className="text-2xl font-bold mb-4">WebSocket Test</h2>
            
            <div className="mb-4">
                <input
                    type="text"
                    value={symbols}
                    onChange={(e) => setSymbols(e.target.value)}
                    className="border p-2 mr-2"
                    placeholder="Enter stock symbols (comma-separated)"
                />
                <button
                    onClick={changeSymbols}
                    className="bg-blue-500 text-white px-4 py-2 rounded mr-2"
                    disabled={!isConnected}
                >
                    Change Symbols
                </button>
                <button
                    onClick={isConnected ? disconnectWebSocket : connectWebSocket}
                    className={`px-4 py-2 rounded ${
                        isConnected 
                            ? 'bg-red-500 text-white' 
                            : 'bg-green-500 text-white'
                    }`}
                >
                    {isConnected ? 'Disconnect' : 'Connect'}
                </button>
            </div>

            {/* Price Updates Display */}
            <div className="mb-4 grid grid-cols-1 md:grid-cols-2 gap-4">
                {Object.entries(priceUpdates).map(([symbol, update]) => (
                    <div key={symbol} className="border rounded p-4 bg-gray-50">
                        <h3 className="font-bold text-lg">{symbol}</h3>
                        <p className="text-xl">${update.price.toFixed(2)}</p>
                        <p className="text-sm text-gray-500">
                            Last update: {new Date(update.timestamp).toLocaleTimeString()}
                        </p>
                    </div>
                ))}
            </div>

            <div className="border rounded p-4 h-96 overflow-y-auto">
                <h3 className="font-bold mb-2">Messages:</h3>
                {messages.map((msg, index) => (
                    <div key={index} className="mb-1">
                        {msg}
                    </div>
                ))}
            </div>
        </div>
    );
};

export default WebSocketTest; 