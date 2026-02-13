# Spam Detection API (FastAPI + Node.js Gateway)

## Overview

A production-ready machine learning-based spam detection system with:

- **FastAPI ML Service**: Python-based ML inference API
- **Node.js Gateway**: Express.js API gateway for request handling
- **ML Model**: TF-IDF + Multinomial Naive Bayes classifier
- **Dataset**: SMS Spam Collection (~5,500 messages)
- **Accuracy**: ~95-98%

## Architecture

```
Client → Node.js API Gateway → FastAPI ML Service → ML Model
```

The system uses a microservices architecture where:
- Node.js handles client requests and provides a gateway
- FastAPI serves ML predictions
- Models are pre-trained and loaded at startup

---

## Project Structure

```
spam-filter/
├── spam_filter/           # Python FastAPI service
│   ├── main/
│   │   ├── main.py       # FastAPI application
│   │   └── config.py     # Configuration settings
│   └── training/
│       ├── train.py      # Model training script
│       ├── spam.csv      # Dataset
│       ├── model.pkl     # Trained model (generated)
│       └── vectorizer.pkl # TF-IDF vectorizer (generated)
├── server/               # Node.js API gateway
│   ├── server.js        # Express server
│   ├── config/
│   │   └── config.js    # Server configuration
│   └── routes/
│       ├── predict.routes.js  # Prediction endpoints
│       └── health.routes.js   # Health check endpoints
├── requirements.txt      # Python dependencies
├── .gitignore           # Git ignore rules
└── README.md            # Documentation
```

---

## Local Setup

### Prerequisites

- Python 3.8+
- Node.js 14+
- pip and npm

### 1. Clone and Setup Environment

```bash
# Clone repository
cd spam-filter

# Copy environment files
cp .env.example .env
cp server/.env.example server/.env
```

### 2. Python FastAPI Service Setup

```bash
# Create virtual environment
python -m venv venv

# Activate virtual environment
# Windows:
venv\Scripts\activate
# Mac/Linux:
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Train the model
cd spam_filter/training
python train.py
cd ../..
```

### 3. Node.js Gateway Setup

```bash
cd server
npm install
cd ..
```

### 4. Start Services

**Terminal 1 - FastAPI ML Service:**
```bash
cd spam_filter/main
python main.py
```
Server runs at: http://localhost:8000
Swagger docs: http://localhost:8000/docs

**Terminal 2 - Node.js Gateway:**
```bash
cd server
npm run dev
```
Server runs at: http://localhost:5000

---

## API Endpoints

### Node.js Gateway (Port 5000)

#### POST /api/predict
Classify a message as spam or ham.

**Request:**
```json
{
  "text": "Congratulations! You won a prize"
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "message": "Congratulations! You won a prize",
    "spam": true,
    "confidence": 0.924
  }
}
```

#### GET /api/health
Check system health status.

**Response:**
```json
{
  "success": true,
  "timestamp": "2026-02-13T10:30:00.000Z",
  "server": {
    "status": "healthy",
    "environment": "development"
  },
  "mlApi": {
    "status": "healthy",
    "url": "http://localhost:8000"
  }
}
```

### FastAPI ML Service (Port 8000)

#### POST /predict
Direct ML prediction endpoint (also accessible via gateway).

#### GET /
Health check endpoint.

#### GET /docs
Interactive API documentation (Swagger UI).

---

## Environment Variables

### Root `.env`
```bash
PORT=8000  # FastAPI port
```

### `server/.env`
```bash
PORT=5000              # Node.js server port
NODE_ENV=development   # Environment mode
ML_API_URL=http://localhost:8000  # FastAPI service URL
```

---

## Model Training

The training script includes:
- Data preprocessing and cleaning
- Train/test split (80/20)
- TF-IDF vectorization with bigrams
- Multinomial Naive Bayes training
- Comprehensive evaluation metrics
- Model and artifact persistence

**Retrain the model:**
```bash
cd spam_filter/training
python train.py
```

**Training outputs:**
- `model.pkl` - Trained classifier
- `vectorizer.pkl` - Fitted TF-IDF vectorizer
- `training_metrics.json` - Performance metrics

---

## Docker Deployment

### Build Image
```bash
docker build -t spam-api ./spam_filter
```

### Run Container
```bash
docker run -p 8000:8000 spam-api
```

---

## Production Deployment

### Deploy FastAPI Service

**Render/Railway/Cloud Run:**
1. Push to GitHub
2. Create new Web Service
3. Select Docker deployment
4. Set environment: `PORT=8000`
5. Deploy

### Deploy Node.js Gateway

1. Push to hosting platform
2. Install dependencies: `npm install`
3. Set environment variables:
 > in server folder
   - `ML_API_URL=<your-fastapi-url>`
   - `NODE_ENV=production`
4. Start: `npm start`

---

## Development Features

### Python Service
- ✅ Type hints and Pydantic models
- ✅ Configuration management
- ✅ Comprehensive error handling
- ✅ CORS enabled
- ✅ Auto-generated API docs

### Node.js Gateway
- ✅ Request validation
- ✅ Health monitoring
- ✅ Environment-based configuration
- ✅ CORS enabled

### Model
- ✅ TF-IDF with unigrams + bigrams
- ✅ Stratified train/test split


---

## Testing

### Test FastAPI Service
```bash
curl -X POST http://localhost:8000/predict \
  -H "Content-Type: application/json" \
  -d '{"text": "Win free lottery tickets now!"}'
```

### Test Node.js Gateway
```bash
curl -X POST http://localhost:5000/api/predict \
  -H "Content-Type: application/json" \
  -d '{"text": "Win free lottery tickets now!"}'
```

### Check Health
```bash
curl http://localhost:5000/
```

---

## Model Performance

- **Algorithm**: Multinomial Naive Bayes
- **Vectorizer**: TF-IDF (max 5000 features, 1-2 grams)
- **Accuracy**: 95-98%
- **Precision**: ~96%
- **Recall**: ~94%
- **F1 Score**: ~95%

---

## Troubleshooting

### ML Service Not Starting
```bash
# Check if model files exist
ls spam_filter/training/*.pkl

# If missing, retrain
cd spam_filter/training && python train.py
```

### Node.js Gateway Connection Issues
```bash
# Verify ML_API_URL in server/.env
# Check if FastAPI is running on port 8000
curl http://localhost:8000/
```

### Port Already in Use
```bash
# Change ports in .env files
# Or kill processes using the ports
```

---

## License

MIT

## Author
MUHAMMED HABEEB RAHMAN K T
[GITHUB](https://github.com/muh-habeeb)