# Multi-service Docker image - Python FastAPI + Node.js Gateway
FROM python:3.11-slim

WORKDIR /app

# Install Node.js and npm
RUN apt-get update && \
    apt-get install -y curl && \
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy and install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy spam_filter directory and train model
COPY spam_filter/ ./spam_filter/
RUN cd spam_filter/training && python train.py

# Copy and install Node.js dependencies
COPY server/ ./server/
RUN cd server && npm install --production

# Copy startup script
COPY start.sh .
RUN chmod +x start.sh

# Expose both ports
EXPOSE 8000 5000

# Run both services
CMD ["./start.sh"]