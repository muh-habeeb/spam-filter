#!/bin/sh

# Start FastAPI ML Service
echo "Starting FastAPI ML Service on port 8000..."
cd /app/ml-service/main
python main.py