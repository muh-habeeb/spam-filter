# Multi-service Docker image - Python FastAPI + Node.js Gateway
FROM python:3.11-slim

WORKDIR /app

# Install Node.js
RUN apt-get update && \
    apt-get install -y curl && \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy project files
COPY . .

# Train model during build
RUN cd ml-service/training && python train.py

# Install Node dependencies
RUN cd server && npm install --omit=dev

# Ensure .env file exists in server directory for Docker environment
RUN echo "ML_API_URL=http://localhost:8000" > /app/server/.env && \
    echo "PORT=5000" >> /app/server/.env && \
    echo "NODE_ENV=production" >> /app/server/.env

# Make startup script executable
RUN chmod +x start.sh

# Set environment for production
ENV NODE_ENV=production

# Expose ports
EXPOSE 8000 5000

CMD ["./start.sh"]