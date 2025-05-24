import { useState, useEffect } from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate, useNavigate, useLocation } from 'react-router-dom';
import Login from './components/Login';
import Dashboard from './components/Dashboard';
import Stock from './components/Stock';
import { authService } from './services/authService';

// Protected Route wrapper component
const ProtectedRoute = ({ children }: { children: React.ReactNode }) => {
  const navigate = useNavigate();
  const location = useLocation();

  useEffect(() => {
    if (!authService.isAuthenticated()) {
      // Redirect to login while saving the attempted url
      navigate('/login', { state: { from: location.pathname } });
    }
  }, [navigate, location]);

  if (!authService.isAuthenticated()) {
    return null;
  }

  return <>{children}</>;
};

function App() {
  const [isAuthenticated, setIsAuthenticated] = useState(false);

  useEffect(() => {
    // Check authentication status when the app loads
    setIsAuthenticated(authService.isAuthenticated());

    // Listen for authentication changes
    const handleAuthChange = (isAuth: boolean) => {
      setIsAuthenticated(isAuth);
    };

    // Subscribe to auth changes
    authService.subscribe(handleAuthChange);

    return () => {
      // Cleanup subscription
      authService.unsubscribe(handleAuthChange);
    };
  }, []);

  return (
    <Router>
      <Routes>
        <Route 
          path="/login" 
          element={
            isAuthenticated ? (
              <Navigate to="/" replace />
            ) : (
              <Login onLoginSuccess={() => setIsAuthenticated(true)} />
            )
          } 
        />
        <Route
          path="/"
          element={
            <ProtectedRoute>
              <Dashboard />
            </ProtectedRoute>
          }
        />
        <Route
          path="/stock/:symbol"
          element={
            <ProtectedRoute>
              <Stock />
            </ProtectedRoute>
          }
        />
        <Route path="*" element={<Navigate to="/" replace />} />
      </Routes>
    </Router>
  );
}

export default App;
