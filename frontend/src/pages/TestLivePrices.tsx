import React from 'react';
import { Container, Typography, Box } from '@mui/material';
import HomeLivePrices from '../components/HomeLivePrices';

const TestLivePrices: React.FC = () => {
    return (
        <Container maxWidth="lg">
            <Box sx={{ my: 4 }}>
                <Typography variant="h4" component="h1" gutterBottom>
                    Live Prices Test Page
                </Typography>
                <Typography variant="body1" color="text.secondary" paragraph>
                    This page demonstrates the live price updates functionality. The prices will update in real-time as they change in the market.
                </Typography>
                <HomeLivePrices />
            </Box>
        </Container>
    );
};

export default TestLivePrices; 