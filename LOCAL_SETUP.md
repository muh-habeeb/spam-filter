# Local Setup Instructions

## Prerequisites
- Python 3.8+ installed
- Node.js 14+ installed
- Git (optional)

---

## Option 1: Run Locally (Recommended for Development)

### Step 1: Setup Python Environment

```powershell
# Navigate to project root
cd "C:\Users\NAIJIL\Desktop\Project\SEM 6\ganesh\spam filter"

# Create virtual environment
python -m venv venv

# Activate virtual environment
.\venv\Scripts\Activate.ps1

# Install Python dependencies
pip install -r requirements.txt
```

### Step 2: Train the Model

```powershell
# Navigate to training directory
cd ml-service\training

# Train the model (creates model.pkl and vectorizer.pkl)
python train.py

# Return to project root
cd ..\..
```

### Step 3: Start FastAPI Service

Open **Terminal 1**:
```powershell
# Activate virtual environment
.\venv\Scripts\Activate.ps1

# Navigate to FastAPI main directory
cd ml-service\main

# Start FastAPI service
python main.py
```

The FastAPI service will run on: **http://localhost:8000**
- API Docs: http://localhost:8000/docs

### Step 4: Setup Node.js Server

Open **Terminal 2** (new terminal):
```powershell
# Navigate to server directory
cd server

# Install Node.js dependencies (first time only)
npm install

# Verify .env file exists and has correct values:
# ML_API_URL=http://localhost:8000
# PORT=5000
# NODE_ENV=development
```

### Step 5: Start Node.js Gateway

In **Terminal 2**:
```powershell
# Start Node.js server
npm run dev
# or for production mode:
# npm start
```

The Node.js gateway will run on: **http://localhost:5000**

---

## Option 2: Run with Docker

### Build Docker Image

```powershell
# Navigate to project root
cd "C:\Users\NAIJIL\Desktop\Project\SEM 6\ganesh\spam filter"

# Build the image
docker build -t spam-api .
```

### Run Docker Container

```powershell
# Run container (both services)
docker run -p 8000:8000 -p 5000:5000 spam-api
```

Access the services:
- **Node.js Gateway**: http://localhost:5000
- **FastAPI Service**: http://localhost:8000
- **API Docs**: http://localhost:8000/docs

---

## Testing the API

### Test FastAPI Directly (Port 8000)

```powershell
# PowerShell
$body = @{
    text = "Congratulations! You won a free prize"
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:8000/predict" -Method Post -Body $body -ContentType "application/json"
```

### Test via Node.js Gateway (Port 5000)

```powershell
# PowerShell
$body = @{
    text = "Congratulations! You won a free prize"
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:5000/api/predict" -Method Post -Body $body -ContentType "application/json"
```

### Using curl

```bash
# Test FastAPI
curl -X POST http://localhost:8000/predict \
  -H "Content-Type: application/json" \
  -d "{\"text\": \"Congratulations! You won a free prize\"}"

# Test Node.js Gateway
curl -X POST http://localhost:5000/api/predict \
  -H "Content-Type: application/json" \
  -d "{\"text\": \"Congratulations! You won a free prize\"}"
```

---

## Troubleshooting

### Issue: "Model files not found"
**Solution**: Train the model first
```powershell
cd ml-service\training
python train.py
```

### Issue: "Port already in use"
**Solution**: Kill the process using the port
```powershell
# Find process using port 8000
netstat -ano | findstr :8000

# Kill the process (replace PID with actual process ID)
taskkill /PID <PID> /F
```

### Issue: "ML_API_URL not defined"
**Solution**: Check server/.env file exists with:
```
ML_API_URL=http://localhost:8000
PORT=5000
NODE_ENV=development
```

### Issue: "Cannot connect to ML API"
**Solution**: 
1. Make sure FastAPI is running on port 8000
2. Check FastAPI logs for errors
3. Test FastAPI directly: `curl http://localhost:8000/`

### Issue: Node modules not found
**Solution**: Install dependencies
```powershell
cd server
npm install
```

---

## Project Structure

```
spam-filter/
├── ml-service/              # FastAPI ML Service
│   ├── main/
│   │   └── main.py         # FastAPI application
│   └── training/
│       ├── train.py        # Training script
│       ├── spam.csv        # Dataset
│       ├── model.pkl       # Trained model (generated)
│       └── vectorizer.pkl  # Vectorizer (generated)
│
├── server/                 # Node.js Gateway
│   ├── server.js          # Express server
│   ├── controller/
│   │   └── predict.controller.js
│   ├── package.json
│   └── .env               # Environment variables
│
├── requirements.txt       # Python dependencies
├── Dockerfile            # Docker configuration
├── start.sh             # Startup script for Docker
└── LOCAL_SETUP.md       # This file
```

---

## Development Workflow

1. **Make changes to Python code**:
   - Edit files in `ml-service/`
   - Restart Python service (Ctrl+C and run `python main.py` again)

2. **Make changes to Node.js code**:
   - Edit files in `server/`
   - Using `npm run dev` will auto-restart on changes
   - Or manually restart: Ctrl+C and run `npm start`

3. **Retrain model**:
   - Navigate to `ml-service/training`
   - Run `python train.py`
   - Restart FastAPI service

---

## Stopping Services

### Stop Local Services
- Press `Ctrl+C` in each terminal window

### Stop Docker Container
```powershell
# List running containers
docker ps

# Stop container (replace <container_id> with actual ID)
docker stop <container_id>
```

---

## Environment Variables

### FastAPI Service (ml-service)
- `PORT`: Port to run on (default: 8000)

### Node.js Gateway (server/.env)
- `ML_API_URL`: URL of FastAPI service
- `PORT`: Port to run on (default: 5000)
- `NODE_ENV`: Environment mode (development/production)

---

## Next Steps

After getting both services running locally:

1. **Test the prediction endpoint**
2. **Check API documentation** at http://localhost:8000/docs
3. **Try different test messages** (spam vs ham)
4. **Monitor logs** in both terminal windows

---

## Quick Reference

| Service | Local URL | Purpose |
|---------|-----------|---------|
| FastAPI ML | http://localhost:8000 | ML predictions |
| FastAPI Docs | http://localhost:8000/docs | API documentation |
| Node.js Gateway | http://localhost:5000 | API gateway |
| Health Check | http://localhost:5000/api/predict | Test endpoint |

---

## Common Commands

```powershell
# Activate Python environment
.\venv\Scripts\Activate.ps1

# Train model
cd ml-service\training && python train.py && cd ..\..

# Start FastAPI
cd ml-service\main && python main.py

# Start Node.js (dev mode)
cd server && npm run dev

# Start Node.js (production)
cd server && npm start

# Build Docker
docker build -t spam-api .

# Run Docker
docker run -p 8000:8000 -p 5000:5000 spam-api
```
