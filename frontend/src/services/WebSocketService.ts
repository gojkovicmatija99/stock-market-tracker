import { create, StateCreator } from 'zustand';

interface PriceUpdate {
    symbol: string;
    price: number;
    timestamp: string;
}

interface WebSocketState {
    isConnected: boolean;
    priceUpdates: Record<string, PriceUpdate>;
    messages: string[];
    connect: (symbols: string[]) => void;
    disconnect: () => void;
    subscribe: (symbols: string[]) => void;
}

const useWebSocketStore = create<WebSocketState>((set: any, get: any) => ({
    isConnected: false,
    priceUpdates: {},
    messages: [],
    ws: null as WebSocket | null,

    connect: (symbols: string[]) => {
        const websocket = new WebSocket('ws://localhost:8082/ws/stock');

        websocket.onopen = () => {
            set({ isConnected: true });
            set((state: WebSocketState) => ({ messages: [...state.messages, 'Connected to WebSocket'] }));
            
            // Subscribe to initial symbols
            symbols.forEach(symbol => {
                websocket.send(symbol);
                set((state: WebSocketState) => ({ messages: [...state.messages, `Subscribed to ${symbol}`] }));
            });
        };

        websocket.onmessage = (event) => {
            try {
                const data = JSON.parse(event.data);
                set((state: WebSocketState) => ({ messages: [...state.messages, `Received: ${event.data}`] }));
                
                // Update price data
                set((state: WebSocketState) => ({
                    priceUpdates: {
                        ...state.priceUpdates,
                        [data.symbol]: {
                            symbol: data.symbol,
                            price: data.price,
                            timestamp: new Date().toISOString()
                        }
                    }
                }));
            } catch (error) {
                set((state: WebSocketState) => ({ messages: [...state.messages, `Error parsing message: ${event.data}`] }));
            }
        };

        websocket.onerror = (error) => {
            set((state: WebSocketState) => ({ messages: [...state.messages, `Error: ${error}`] }));
        };

        websocket.onclose = () => {
            set({ isConnected: false });
            set((state: WebSocketState) => ({ messages: [...state.messages, 'Disconnected from WebSocket'] }));
        };

        // Store WebSocket instance
        (get() as any).ws = websocket;
    },

    disconnect: () => {
        const ws = (get() as any).ws;
        if (ws) {
            ws.close();
            (get() as any).ws = null;
        }
    },

    subscribe: (symbols: string[]) => {
        const ws = (get() as any).ws;
        if (ws && ws.readyState === WebSocket.OPEN) {
            // Clear existing subscriptions
            set({ priceUpdates: {} });
            set((state: WebSocketState) => ({ messages: [...state.messages, 'Clearing existing subscriptions'] }));
            
            // Subscribe to new symbols
            symbols.forEach(symbol => {
                ws.send(symbol);
                set((state: WebSocketState) => ({ messages: [...state.messages, `Subscribed to ${symbol}`] }));
            });
        }
    }
}));

export default useWebSocketStore; 