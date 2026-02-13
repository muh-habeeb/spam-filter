# Python FastAPI Spam Detection Service
FROM python:3.11-slim

WORKDIR /app

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy project files
COPY ml-service/ ./ml-service/

# Train model during build
RUN cd ml-service/training && python train.py

# Expose port
EXPOSE 8000

# Start FastAPI service
WORKDIR /app/ml-service/main
CMD ["python", "main.py"]