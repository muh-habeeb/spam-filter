#!/bin/sh

# Check if we're on Render (single port deployment)
if [ -n "$RENDER" ] || [ "$NODE_ENV" = "production" ]; then
  echo "Production mode detected"
  
  # On Render, start FastAPI on internal port 8000
  echo "Starting FastAPI ML Service on port 8000..."
  cd /app/ml-service/main
  PORT=8000 python main.py &
  
  # Wait for FastAPI to initialize
  sleep 8
  
  # Start Node.js on Render's PORT (usually 10000)
  echo "Starting Node.js Gateway on port $PORT..."
  cd /app/server
  ML_API_URL=http://localhost:8000 node server.js
else
  # Local development - use separate ports
  echo "Development mode"
  
  # Start FastAPI ML Service in background
  echo "Starting FastAPI ML Service on port 8000..."
  cd /app/ml-service/main
  python main.py &
  
  # Wait for FastAPI to initialize
  sleep 5
  
  # Start Node.js Gateway in foreground
  echo "Starting Node.js Gateway on port 5000..."
  cd /app/server
  node server.js
fi