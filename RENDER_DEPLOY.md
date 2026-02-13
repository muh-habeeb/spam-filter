# Render Deployment Guide

## 🚀 Deploy to Render

### Step 1: Push to GitHub
```powershell
git add .
git commit -m "Ready for deployment"
git push
```

### Step 2: Create Web Service on Render

1. Go to https://render.com and sign in
2. Click **"New +"** → **"Web Service"**
3. Connect your GitHub repository
4. Configure:
   - **Name**: `spam-filter-api` (or your choice)
   - **Environment**: `Docker`
   - **Region**: Choose closest to your users
   - **Branch**: `main` (or your branch)
   - **Instance Type**: Free or Starter

### Step 3: Environment Variables (Optional)

Render will automatically detect Docker and use the Dockerfile. No additional environment variables needed as they're set in the Dockerfile!

**Optional overrides:**
- `PORT` - Render sets this automatically (usually 10000)
- `NODE_ENV` - Set to `production` (already in Dockerfile)

### Step 4: Deploy

Click **"Create Web Service"** and wait for deployment (5-10 minutes for first build).

---

## 📡 Access Your Deployed API

Once deployed, Render gives you a URL like:
```
https://spam-filter-api-xxxx.onrender.com
```

### Test the Deployment

**Health Check:**
```powershell
curl https://your-app-name.onrender.com/
```

**Predict Spam:**
```powershell
$body = @{ text = "WIN FREE PRIZE NOW!" } | ConvertTo-Json
Invoke-RestMethod -Uri "https://your-app-name.onrender.com/api/predict" -Method Post -Body $body -ContentType "application/json"
```

---

## 🔧 How It Works on Render

1. **Render detects Dockerfile** and builds the image
2. **Trains ML model** during build (cached after first deployment)
3. **Sets PORT environment variable** (usually 10000)
4. **Runs start.sh script** which:
   - Starts FastAPI on internal port 8000
   - Starts Node.js on Render's PORT (exposed publicly)
5. **Node.js gateway** forwards prediction requests to internal FastAPI

---

## ⚡ Important Notes

### Single Port Exposure
- On Render, only ONE port is publicly accessible
- We expose Node.js gateway on Render's PORT
- FastAPI runs internally on port 8000
- Gateway proxies requests to FastAPI

### Free Tier Limitations
- Service spins down after 15 minutes of inactivity
- First request after spin-down takes 30-60 seconds (cold start)
- Upgrade to paid tier for always-on service

### Build Time
- First deployment: 5-10 minutes (trains model)
- Subsequent deployments: 2-5 minutes (uses cached model)

---

## 🐛 Troubleshooting

### Deployment Failed
```
Check Render logs for specific errors:
1. Click on your service
2. Go to "Logs" tab
3. Look for red error messages
```

### Service Returns 503
- Service is starting up (wait 1-2 minutes)
- Check logs for errors
- Verify both FastAPI and Node.js started

### "Cannot POST /api/predict"
Make sure you're using the correct endpoint:
```
✅ https://your-app.onrender.com/api/predict
❌ https://your-app.onrender.com/predict
```

### Model Training Fails
- Check if `spam.csv` exists in `ml-service/training/`
- Verify `requirements.txt` has all dependencies
- Check Render build logs

---

## 📊 Monitoring

### Check Service Status
```powershell
# Health check
curl https://your-app-name.onrender.com/

# Should return:
{
  "status": "OK",
  "gateway": "running",
  "mlApi": { "message": "..." }
}
```

### View Logs
Go to Render Dashboard → Your Service → Logs

---

## 🔄 Update Deployment

```powershell
# Make changes locally
git add .
git commit -m "Update feature"
git push

# Render auto-deploys from GitHub
# Watch deployment in Render dashboard
```

---

## 💰 Cost Estimate

| Plan | Cost | Features |
|------|------|----------|
| Free | $0/mo | 750 hours/mo, spins down after inactivity |
| Starter | $7/mo | Always on, 512MB RAM |
| Standard | $25/mo | 2GB RAM, better performance |

---

## 🎯 Production Checklist

- [ ] Model trained and files exist
- [ ] Dockerfile builds successfully locally
- [ ] Environment variables configured
- [ ] CORS origins updated with production URL
- [ ] Tested locally with Docker
- [ ] GitHub repository connected to Render
- [ ] Render service created and deployed
- [ ] Tested production API endpoints
- [ ] Monitoring/logging enabled

---

## 📝 Example Production Usage

```javascript
// Frontend JavaScript
const predictSpam = async (text) => {
  const response = await fetch('https://your-app-name.onrender.com/api/predict', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ text })
  });
  return await response.json();
};

// Usage
const result = await predictSpam("Congratulations! You won!");
console.log(result); // { message: "...", spam: true, confidence: 0.95 }
```

---

## 🔗 Useful Links

- [Render Documentation](https://render.com/docs)
- [Docker Deployment Guide](https://render.com/docs/docker)
- [Environment Variables](https://render.com/docs/environment-variables)

---

## 🆘 Support

If you encounter issues:
1. Check Render logs first
2. Test locally with Docker: `docker build -t spam-api . && docker run -p 8000:8000 -p 5000:5000 spam-api`
3. Verify all files are committed to GitHub
4. Contact Render support if infrastructure issues
