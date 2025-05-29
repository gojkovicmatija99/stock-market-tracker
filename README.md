# Stock Market Tracker - Technical Documentation

## Thesis Project: Implementation of Reactive Pattern in Microservices Architecture

This project demonstrates the implementation of reactive programming patterns in a microservices architecture for a stock market tracking application. The system showcases how reactive streams can be used to handle concurrent requests across multiple microservices efficiently.

## System Architecture

### 1. Authentication Service (Auth-Service)
#### REST Endpoints
- `POST /auth/register`
  - Purpose: User registration
  - Request Body:
  ```json
  {
    "username": "user@example.com",
    "password": "password",
    "firstName": "John",
    "lastName": "Doe"
  }
  ```

- `POST /auth/login`
  - Purpose: User authentication
  - Request Body:
  ```json
  {
    "username": "user@example.com",
    "password": "password"
  }
  ```
  - Response: JWT token

- `POST /auth/validate`
  - Purpose: JWT token validation
  - Authentication: JWT Bearer Token

### 2. User Service (User-Service)
#### REST Endpoints
- `GET /users/{userId}`
  - Purpose: Retrieve user profile
  - Authentication: JWT Bearer Token

- `PUT /users/{userId}`
  - Purpose: Update user profile
  - Authentication: JWT Bearer Token

- `DELETE /users/{userId}`
  - Purpose: Delete user profile
  - Authentication: JWT Bearer Token

### 3. Stock Service (Stock-Service)
#### WebSocket Endpoints
- `ws://localhost:8082/ws/stock`
  - Purpose: Real-time stock price streaming
  - Protocol: WebSocket
  - Authentication: JWT Bearer Token
  - Message Format:
  ```json
  {
    "symbol": "AAPL",
    "price": 150.25,
    "timestamp": "2024-03-20T10:30:00Z"
  }
  ```

#### REST Endpoints
- `GET /stocks`
  - Purpose: Search available stocks
  - Authentication: JWT Bearer Token

- `GET /stocks/{symbol}`
  - Purpose: Get stock details
  - Authentication: JWT Bearer Token

### 4. Portfolio Service (Portfolio-Service)
#### REST Endpoints
- `GET /portfolio`
  - Purpose: Get current portfolio state
  - Authentication: JWT Bearer Token

- `POST /portfolio/stocks`
  - Purpose: Add stock to portfolio
  - Authentication: JWT Bearer Token

- `DELETE /portfolio/stocks/{symbol}`
  - Purpose: Remove stock from portfolio
  - Authentication: JWT Bearer Token

- `GET /portfolio/history`
  - Purpose: Get portfolio historical data
  - Parameters:
    - `interval`: Time interval (1min to 1month)
  - Authentication: JWT Bearer Token

### 5. Notification Service (Notification-Service)
#### REST Endpoints
- `POST /notifications`
  - Purpose: Send notification
  - Authentication: JWT Bearer Token
  - Request Body:
  ```json
  {
    "userId": "user123",
    "type": "PORTFOLIO_UPDATE",
    "message": "Your portfolio value has changed",
    "channel": "EMAIL"
  }
  ```

## Reactive Flow Example

### Stock Details Request Flow
1. Client sends request for stock details
2. API Gateway receives request and initiates reactive calls
3. Parallel execution:
   - Auth-Service validates JWT token
   - Stock-Service fetches stock information
   - Portfolio-Service retrieves user's position
4. Results are combined and returned to client

## Technical Implementation

### Backend Services
- Java 17+
- Spring WebFlux
- Project Reactor
- R2DBC for reactive database access
- JWT authentication
- WebSocket support

### Frontend
- React 18+
- TypeScript 5+
- Chart.js 4+
- Tailwind CSS 3+
- WebSocket client

## Development Setup

### Docker Compose
```yaml
version: '3.8'
services:
  auth-service:
    build: ./auth-service
    ports:
      - "8081:8081"
  
  user-service:
    build: ./user-service
    ports:
      - "8082:8082"
  
  stock-service:
    build: ./stock-service
    ports:
      - "8083:8083"
  
  portfolio-service:
    build: ./portfolio-service
    ports:
      - "8084:8084"
  
  notification-service:
    build: ./notification-service
    ports:
      - "8085:8085"
  
  api-gateway:
    build: ./api-gateway
    ports:
      - "8080:8080"
```

## Performance Considerations

### Reactive Streams
- Non-blocking I/O operations
- Backpressure handling
- Efficient resource utilization
- Scalable request processing

### Microservices Communication
- Event-driven architecture
- Message queues for async communication
- Circuit breaker pattern
- Retry mechanisms

## Monitoring and Logging

### Backend Services
- Reactive metrics collection
- Distributed tracing
- Error logging
- Performance monitoring

### Frontend
- Console logging
- Error boundaries
- Performance monitoring
- WebSocket connection status 