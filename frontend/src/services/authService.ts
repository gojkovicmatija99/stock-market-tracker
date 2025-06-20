interface LoginResponse {
  token: string;
  user: {
    id: string;
    username: string;
    email: string;
  };
}

type AuthChangeListener = (isAuthenticated: boolean) => void;

class AuthService {
  private baseUrl: string;
  private tokenKey = 'jwt_token';
  private listeners: Set<AuthChangeListener> = new Set();

  constructor() {
    this.baseUrl = 'http://localhost:8081';
  }

  subscribe(listener: AuthChangeListener): void {
    this.listeners.add(listener);
  }

  unsubscribe(listener: AuthChangeListener): void {
    this.listeners.delete(listener);
  }

  private notifyListeners(isAuthenticated: boolean): void {
    this.listeners.forEach(listener => listener(isAuthenticated));
  }

  async login(username: string, password: string): Promise<LoginResponse> {
    try {
      const response = await fetch(`${this.baseUrl}/auth/login`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        credentials: 'include',
        body: JSON.stringify({ username, password }),
      });

      if (!response.ok) {
        const errorData = await response.json().catch(() => null);
        throw new Error(errorData?.message || 'Login failed');
      }

      const data = await response.json();
      console.log('Login response:', data);
      this.setToken(data.access_token);
      this.notifyListeners(true);
      return data;
    } catch (error) {
      console.error('Login error:', error);
      throw error;
    }
  }

  logout(): void {
    localStorage.removeItem(this.tokenKey);
    this.notifyListeners(false);
  }

  getToken(): string | null {
    return localStorage.getItem(this.tokenKey);
  }

  private setToken(token: string): void {
    console.log('Setting token:', token);
    localStorage.setItem(this.tokenKey, token);
  }

  isAuthenticated(): boolean {
    const token = this.getToken();
    console.log("tkn" + token)
    return !!token;
  }

  // Helper method to get auth headers
  getAuthHeaders(): HeadersInit {
    const token = this.getToken();
    console.log('Token:', token);
    return {
      'Authorization': `Bearer ${token}`,
      'Content-Type': 'application/json',
    };
  }

  async refreshToken(): Promise<void> {
    const refreshToken = localStorage.getItem('refreshToken');
    if (!refreshToken) {
      throw new Error('No refresh token available');
    }

    const response = await fetch(`${this.baseUrl}/auth/refresh`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ refreshToken }),
    });

    if (!response.ok) {
      throw new Error('Failed to refresh token');
    }

    const data = await response.json();
    this.setToken(data.access_token);
    localStorage.setItem('refreshToken', data.refresh_token);
    this.notifyListeners(true);
  }
}

export const authService = new AuthService(); 