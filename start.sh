#!/bin/sh

# Start FastAPI ML Service in background
echo "Starting FastAPI ML Service on port 8000..."
cd /app/spam_filter/main
python main.py &

# Wait for FastAPI to initialize
sleep 5

# Start Node.js Gateway in foreground
echo "Starting Node.js Gateway on port 5000..."
cd /app/server
node server.js