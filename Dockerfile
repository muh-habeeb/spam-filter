# # Multi-service Docker image - Python FastAPI + Node.js Gateway
# FROM python:3.11-slim

# WORKDIR /app

# # Install Node.js and npm
# RUN apt-get update && \
#     apt-get install -y curl && \
#     curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
#     apt-get install -y nodejs && \
#     apt-get clean && \
#     rm -rf /var/lib/apt/lists/*

# # Copy and install Python dependencies
# COPY requirements.txt .
# RUN pip install --no-cache-dir -r requirements.txt

# # Copy spam_filter directory and train model
# COPY spam_filter/ ./spam_filter/
# RUN cd spam_filter/training && python train.py

# # Copy and install Node.js dependencies
# COPY server/package*.json ./server/
# RUN cd server && npm install --production

# # Copy server code
# COPY server/ ./server/

# # Create production .env for server
# RUN echo "PORT=5000" > ./server/.env && \
#     echo "NODE_ENV=production" >> ./server/.env && \
#     echo "ML_API_URL=http://localhost:8000" >> ./server/.env

# # Copy startup script
# COPY start.sh .
# RUN chmod +x start.sh

# # Expose both ports
# EXPOSE 8000 5000

# # Run both services
# CMD ["./start.sh"]


FROM python:3.11-slim

WORKDIR /app

# Install Node.js
RUN apt-get update && \
    apt-get install -y curl && \
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy project files
COPY . .

# Train model during build
RUN cd spam_filter/training && python train.py

# Install Node dependencies
RUN cd server && npm install --production

# Make startup script executable
RUN chmod +x start.sh

# Render exposes only one port
EXPOSE 10000

CMD ["./start.sh"]