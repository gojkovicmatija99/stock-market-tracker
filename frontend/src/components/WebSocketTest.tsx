import { useState, useEffect } from 'react';

const WebSocketTest = () => {
    const [messages, setMessages] = useState<string[]>([]);
    const [symbol, setSymbol] = useState('AAPL');
    const [ws, setWs] = useState<WebSocket | null>(null);
    const [isConnected, setIsConnected] = useState(false);

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
            // Subscribe to the symbol
            websocket.send(symbol);
        };

        websocket.onmessage = (event) => {
            setMessages(prev => [...prev, `Received: ${event.data}`]);
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

    const changeSymbol = (newSymbol: string) => {
        setSymbol(newSymbol);
        if (ws && ws.readyState === WebSocket.OPEN) {
            ws.send(newSymbol);
        }
    };

    return (
        <div className="p-4">
            <h2 className="text-2xl font-bold mb-4">WebSocket Test</h2>
            
            <div className="mb-4">
                <input
                    type="text"
                    value={symbol}
                    onChange={(e) => setSymbol(e.target.value)}
                    className="border p-2 mr-2"
                    placeholder="Enter stock symbol"
                />
                <button
                    onClick={() => changeSymbol(symbol)}
                    className="bg-blue-500 text-white px-4 py-2 rounded mr-2"
                    disabled={!isConnected}
                >
                    Change Symbol
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