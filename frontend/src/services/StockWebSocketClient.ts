import { BaseWebSocketClient } from './BaseWebSocketClient';
import { authService } from './authService';

export class StockWebSocketClient extends BaseWebSocketClient {
    private priceUpdateCallback: ((symbol: string, price: number) => void) | null = null;

    constructor() {
        const wsUrl = import.meta.env.VITE_WS_URL || 'ws://localhost:8082/ws/stock';
        super(wsUrl);
    }

    async connect() {
        try {
            const token = await authService.getToken();
            if (!token) {
                console.error('No authentication token available');
                return;
            }

            const ws = new WebSocket(this.url);
            ws.onopen = () => {
                console.log('WebSocket connected, sending authentication token');
                ws.send(JSON.stringify({ type: 'auth', token }));
            };

            this.setWebSocket(ws);
            this.setupWebSocket();
        } catch (error) {
            console.error('Error connecting to WebSocket:', error);
        }
    }

    getWebSocket(): WebSocket | null {
        return this.ws;
    }

    subscribe(symbol: string) {
        if (this.ws?.readyState === WebSocket.OPEN) {
            this.ws.send(symbol);
        }
    }

    unsubscribe(symbol: string) {
        if (this.ws?.readyState === WebSocket.OPEN) {
            this.ws.send(JSON.stringify({ type: 'unsubscribe', symbol }));
        }
    }

    onPriceUpdate(callback: (symbol: string, price: number) => void) {
        this.priceUpdateCallback = callback;
        this.onMessage('price_update', (data: { symbol: string; price: number }) => {
            if (this.priceUpdateCallback) {
                this.priceUpdateCallback(data.symbol, data.price);
            }
        });
    }
} 