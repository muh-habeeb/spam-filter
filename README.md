# Spam Detection API

Machine learning-based spam detection system using FastAPI and Node.js.

## 🎯 Features

- **ML Model**: TF-IDF + Multinomial Naive Bayes classifier
- **FastAPI Backend**: Python ML inference service
- **Node.js Gateway**: Express API gateway
- **Accuracy**: ~95-98% on SMS Spam Collection dataset
- **Docker Ready**: Single container deployment

---

## 🚀 Quick Start

### Option 1: Docker (Recommended)

```powershell
# Build the image
docker build -t spam-api .

# Run the container
docker run -p 8000:8000 spam-api
```

**🔍 Important - Docker Networking:**

When the container starts, you'll see:
```
INFO: Uvicorn running on http://0.0.0.0:8000
```

**What does `0.0.0.0` mean?**
- `0.0.0.0` means the server is listening on ALL network interfaces inside the container
- You should access it using `localhost` on your machine

**Access the service:**
- **FastAPI**: http://localhost:8000
- **API Docs**: http://localhost:8000/docs

The `-p 8000:8000` maps container port 8000 to your localhost:8000, so even though the container shows `0.0.0.0`, you use `localhost` in your browser!

---

### Option 2: Local Development

**Step 1: Setup Python Service**

```powershell
# Create and activate virtual environment
python -m venv venv
.\venv\Scripts\Activate.ps1

# Install dependencies
pip install -r requirements.txt

# Train the model
cd ml-service\training
python train.py
cd ..\..
```

**Step 2: Start FastAPI**

```powershell
cd ml-service\main
python main.py
```
✅ FastAPI runs at: http://localhost:8000
✅ API Docs at: http://localhost:8000/docs

---

## 📡 API Usage

### Predict Spam via Gateway

**PowerShell:**
```powershell
$body = @{ text = "Congratulations! You won a free prize!" } | ConvertTo-Json
Invoke-RestMethod -Uri "http://localhost:5000/api/predict" -Method Post -Body $body -ContentType "application/json"
```

**cURL:**

**PowerShell:**
```powershell
$body = @{ text = "Congratulations! You won a free prize!" } | ConvertTo-Json
Invoke-RestMethod -Uri "http://localhost:8000/predict" -Method Post -Body $body -ContentType "application/json"
```

**cURL:**
```bash
curl -X POST http://localhost:8000/predict \
  -H "Content-Type: application/json" \
  -d '{"text": "Congratulations! You won a free prize!"}'
```

**Response:**
```json
{
  "message": "Congratulations! You won a free prize!",
  "spam": true,
  "confidence": 0.924
}
```

### Check Health

```powershell
curl http://localhost:8000/
```

**Response:**
```json
{
  "message": "Spam Filter API is running. Use POST /predict to classify messages."
spam-filter/
├── ml-service/              # Python FastAPI service
│   ├── main/
│   │   └── main.py         # FastAPI application
│   └── training/
│       ├── train.py        # Model training script
│       ├── spam.csv        # SMS spam dataset
│       ├── model.pkl       # Trained model (generated)
│       └── vectorizer.pkl  # TF-IDF vectorizer (generated)
│
├── server/                  # Node.js Express gateway
│   ├── server.js           # Express server
│   ├── controller/
│   │   └── predict.controller.js
│   └── .env                # Environment variables
│
├── Dockerfile              # Multi-service container
├── start.sh               # Container startup script
└── requirements.txt       # Python dependencies
```

---

## 🔧 Configuration

### Environment Variables

**Optional** - FastAPI will use port 8000 by default.

To change the port, set:
```bash
PORT=8000  # or any other port
```

---

## 🐳 Docker Details

### What Happens When You Run Docker?

1. **Container starts** with Python environment
2. **Model is trained** during image build (or uses existing model)
3. **FastAPI starts** on port 8000
4. **Port is exposed** to your host machine via `-p 8000:8000`

### Understanding 0.0.0.0 vs localhost

| Address | Meaning | When to Use |
|---------|---------|-------------|
| `0.0.0.0` | Listen on all interfaces | Server binding (inside container) |
| `localhost` | Your local machine | Client access (from browser/curl) |

**Example:**
- Container logs: `Uvicorn running on http://0.0.0.0:8000` ✅ (server binding)
- You access: `http://localhost:8000` ✅ (from your machine)
- Don't use: `http://0.0.0.0:8000` in browser ❌ (won't work properly)

---

## 🧪 Testing

### Test Node.js Gateway
```powersHealth Check
```powershell
curl http://localhost:8000/
```

### Test Spam Prediction
```powershell
$spam = @{ text = "YOU WON $1000! Click here now!" } | ConvertTo-Json
$ham = @{ text = "Meeting at 3pm tomorrow" } | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:8000/predict" -Method Post -Body $spam -ContentType "application/json"
Invoke-RestMethod -Uri "http://localhost:8000

### Interactive API Documentation

Visit http://localhost:8000/docs for Swagger UI where you can:
- See all endpoints
- Test API calls directly
- View request/response schemas

---

## 📊 Model Performance

| Metric | Score |
|--------|-------|
| **Accuracy** | 95-98% |
| **Precision** | ~96% |
| **Recall** | ~94% |
| **F1 Score** | ~95% |

**Model Details:**
- Algorithm: Multinomial Naive Bayes
- Features: TF-IDF (unigrams + bigrams, max 5000 features)
- Dataset: SMS Spam Collection (~5,500 messages)
- Train/Test Split: 80/20 (stratified)

---

## 🔄 Retrain Model

```powershell
cd ml-service\training
python train.py
```

**Outputs:**
- `model.pkl` - Trained classifier
- `vectorizer.pkl` - TF-IDF vectorizer
- `training_metrics.json` - Performance metrics

---

## 🛠️ Troubleshooting

### "Model files not found"
```powershell
cd ml-service\training
python train.py
```

### "Port already in use"
```powershell
# Find process using port 8000
netstat -ano | findstr :8000

# Kill the process (replace <PID> with actual ID)
taskkill /PID <PID> /F
```

### "ML_API_URL not defined" (Docker)
The Dockerfile automatically creates `.env` file. If error persists:
```powershell
# Rebuild image
docker build -t spam-api .
```

### "Cannot connect to ML API" (Local)
1. Ensure FastAPI is running: `curl http://localhost:8000/`
2. Check `server/.env` has: `ML_API_URL=http://localhost:8000`
3. Verify both services are on correct ports

### Docker Container Immediately Exits
```powershell
# Check logs
docker ps -a  # Find container ID
docker logs <container_id>

# Common fix: Rebuild with no cache
docker build --no-cache -t spam-api .
```

---

## 🌐 Production Deployment

### Deploy on Render (Recommended)

**Quick Steps:**
1. Push code to GitHub
2. Create Web Service on Render
3. Connect GitHub repository
4. Select **Docker** environment
5. Deploy!

Render will automatically:
- Build the Docker image
- Train the ML model
- Start FastAPI service
- Provide a public URL (e.g., `https://your-app.onrender.com`)

**Access your deployed API:**
```
https://your-app.onrender.com/predict
https://your-app.onrender.com/docs
```

### Other Platforms

Works on any Docker-supporting platform:
- Railway
- Heroku
- DigitalOcean App Platform
- Google Cloud Run
- AWS ECS

---

## 📝 Additional Resources

- **Local Setup Guide**: See [LOCAL_SETUP.md](LOCAL_SETUP.md) for detailed instructions
- **Refactoring Notes**: See [REFACTORING.md](REFACTORING.md) for code improvements

---

## 👨‍💻 Author

**MUHAMMED HABEEB RAHMAN K T**  
[GitHub](https://github.com/muh-habeeb)

---

## 📄 License

MIT