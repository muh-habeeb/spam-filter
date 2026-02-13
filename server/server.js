import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import predict from "./controller/predict.controller.js";
import axios from "axios";
dotenv.config();

const app = express();

// CORS configuration - Allow all in production, restrict in development
const corsOptions = {
  origin: process.env.NODE_ENV === 'production' 
    ? '*' 
    : "*",
  methods: ["GET", "POST"],
  allowedHeaders: ["Content-Type"],
};

app.use(cors(corsOptions));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use("/api/predict", predict);

app.get("/", async (req, res) => {
    console.log(window.location)
  try {
    // Try to check ML API health (optional)
    const mlApiUrl = process.env.ML_API_URL || "http://localhost:8000";
    const response = await axios.get(mlApiUrl, { timeout: 3000 });
    res.status(200).json({ 
      status: "OK", 
      gateway: "running",
      mlApi: response.data 
    });
  } catch (error) {
    // Still return OK even if ML API check fails
    res.status(200).json({ 
      status: "OK", 
      gateway: "running",
      mlApi: "unavailable" 
    });
  }
});

const ML_API_URL = process.env.ML_API_URL || "http://localhost:8000";
console.log(`ML API URL: ${ML_API_URL}`);

const PORT = process.env.PORT || 5000;

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
