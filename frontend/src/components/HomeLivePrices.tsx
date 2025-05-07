import React, { useEffect, useState } from 'react';
import { StockWebSocketClient } from '../services/StockWebSocketClient';
import { Box, Typography, Paper, Grid, CircularProgress } from '@mui/material';

interface PriceData {
    symbol: string;
    price: number;
    change: number;
    changePercent: number;
}

const HomeLivePrices: React.FC = () => {
    const [prices, setPrices] = useState<Record<string, PriceData>>({});
    const [isConnected, setIsConnected] = useState(false);
    const [loading, setLoading] = useState(true);

    // Popular stocks to display
    const popularSymbols = ['AAPL', 'MSFT', 'GOOGL', 'AMZN', 'META', 'TSLA', 'NVDA', 'JPM', 'V', 'WMT'];

    useEffect(() => {
        const stockWebSocketClient = new StockWebSocketClient();

        // Set up connection status listener
        const handleConnectionStatus = (status: boolean) => {
            setIsConnected(status);
            if (status) {
                setLoading(false);
            }
        };

        stockWebSocketClient.onConnectionChange(handleConnectionStatus);

        // Set up price update listener
        const handlePriceUpdate = (symbol: string, price: number) => {
            setPrices(prevPrices => {
                const prevPrice = prevPrices[symbol]?.price || price;
                const change = price - prevPrice;
                const changePercent = (change / prevPrice) * 100;

                return {
                    ...prevPrices,
                    [symbol]: {
                        symbol,
                        price,
                        change,
                        changePercent
                    }
                };
            });
        };

        stockWebSocketClient.onPriceUpdate(handlePriceUpdate);

        // Connect and subscribe to symbols
        stockWebSocketClient.connect();
        popularSymbols.forEach(symbol => {
            stockWebSocketClient.subscribe(symbol);
        });

        // Cleanup
        return () => {
            popularSymbols.forEach(symbol => {
                stockWebSocketClient.unsubscribe(symbol);
            });
            stockWebSocketClient.disconnect();
        };
    }, []);

    const getPriceColor = (change: number) => {
        if (change > 0) return 'success.main';
        if (change < 0) return 'error.main';
        return 'text.primary';
    };

    if (loading) {
        return (
            <Box display="flex" justifyContent="center" alignItems="center" minHeight="200px">
                <CircularProgress />
            </Box>
        );
    }

    return (
        <Paper elevation={3} sx={{ p: 3, mb: 4 }}>
            <Typography variant="h5" gutterBottom>
                Live Market Prices
            </Typography>
            <Typography variant="body2" color="text.secondary" gutterBottom>
                {isConnected ? 'Connected to live data' : 'Disconnected - attempting to reconnect...'}
            </Typography>
            <Grid container spacing={2}>
                {popularSymbols.map(symbol => {
                    const priceData = prices[symbol];
                    return (
                        <Grid item key={symbol} sx={{ width: { xs: '100%', sm: '50%', md: '33.33%', lg: '20%' } }}>
                            <Paper elevation={1} sx={{ p: 2 }}>
                                <Typography variant="h6" gutterBottom>
                                    {symbol}
                                </Typography>
                                <Typography variant="body1" color={getPriceColor(priceData?.change || 0)}>
                                    ${priceData?.price?.toFixed(2) || '--'}
                                </Typography>
                                {priceData && (
                                    <Typography 
                                        variant="body2" 
                                        color={getPriceColor(priceData.change)}
                                    >
                                        {priceData.change > 0 ? '+' : ''}
                                        {priceData.change.toFixed(2)} ({priceData.changePercent.toFixed(2)}%)
                                    </Typography>
                                )}
                            </Paper>
                        </Grid>
                    );
                })}
            </Grid>
        </Paper>
    );
};

export default HomeLivePrices; 