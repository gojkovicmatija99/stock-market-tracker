export class BaseWebSocketClient {
    private ws: WebSocket | null = null;
    private reconnectAttempts = 0;
    private maxReconnectAttempts = 5;
    private reconnectTimeout = 1000; // 1 second
    private messageHandlers: Map<string, (data: any) => void> = new Map();
    private connectionHandlers: ((connected: boolean) => void)[] = [];
    protected url: string;

    constructor(url: string) {
        console.log('Creating WebSocket client for URL:', url);
        this.url = url;
    }

    protected setUrl(url: string) {
        console.log('Setting WebSocket URL to:', url);
        this.url = url;
    }

    protected setWebSocket(ws: WebSocket) {
        this.ws = ws;
    }

    async connect() {
        try {
            console.log('Attempting to connect to WebSocket at:', this.url);
            this.ws = new WebSocket(this.url);
            this.setupWebSocket();
        } catch (error) {
            console.error('WebSocket connection error:', error);
            this.handleReconnect();
        }
    }

    protected setupWebSocket() {
        if (!this.ws) return;

        this.ws.onopen = () => {
            console.log('WebSocket connected successfully to:', this.url);
            this.reconnectAttempts = 0;
            this.notifyConnectionStatus(true);
        };

        this.ws.onmessage = (event) => {
            try {
                console.log('Received WebSocket message:', event.data);
                const message = JSON.parse(event.data);
                console.log('Parsed message:', message);
                this.handleMessage(message);
            } catch (error) {
                console.error('Error parsing WebSocket message:', error);
            }
        };

        this.ws.onclose = (event) => {
            console.log('WebSocket disconnected:', event.code, event.reason);
            console.log('URL:', this.url);
            this.notifyConnectionStatus(false);
            this.handleReconnect();
        };

        this.ws.onerror = (error) => {
            console.error('WebSocket error:', error);
            console.error('URL:', this.url);
            this.notifyConnectionStatus(false);
        };
    }

    private handleReconnect() {
        if (this.reconnectAttempts < this.maxReconnectAttempts) {
            this.reconnectAttempts++;
            console.log(`Attempting to reconnect (${this.reconnectAttempts}/${this.maxReconnectAttempts})...`);
            setTimeout(() => this.connect(), this.reconnectTimeout * this.reconnectAttempts);
        } else {
            console.error('Max reconnection attempts reached');
        }
    }

    private handleMessage(message: any) {
        const { type, data } = message;
        console.log('Handling message type:', type, 'with data:', data);
        const handler = this.messageHandlers.get(type);
        if (handler) {
            handler(data);
        } else {
            console.warn('No handler registered for message type:', type);
        }
    }

    private notifyConnectionStatus(connected: boolean) {
        console.log('Connection status changed:', connected);
        this.connectionHandlers.forEach(handler => handler(connected));
    }

    send(type: string, data: any) {
        if (this.ws?.readyState === WebSocket.OPEN) {
            const message = JSON.stringify({ type, data });
            console.log('Sending WebSocket message:', message);
            this.ws.send(message);
        } else {
            console.error('WebSocket is not connected. Current state:', this.ws?.readyState);
            console.error('URL:', this.url);
        }
    }

    onMessage(type: string, handler: (data: any) => void) {
        console.log('Registering handler for message type:', type);
        this.messageHandlers.set(type, handler);
    }

    onConnectionChange(handler: (connected: boolean) => void) {
        this.connectionHandlers.push(handler);
    }

    disconnect() {
        if (this.ws) {
            console.log('Disconnecting WebSocket...');
            this.ws.close();
            this.ws = null;
        }
    }
} 