import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import predict from "./controller/predict.controller.js";
import axios from "axios";
dotenv.config();

const app = express();

app.use(
  cors({
    origin: [
      "localhost:8000",
      "http://localhost:8000",
      "localhost:5000",
      "http://localhost:5000",
      "https://spam-filter-4tjo.onrender.com",
      "http://spam-filter-4tjo.onrender.com",
    ],
    methods: ["GET", "POST"],
    allowedHeaders: ["Content-Type"],
  }),
);
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use("/api/predict", predict);

app.get("/", async (req, res) => {
  const response = await axios.get("http://localhost:8000/");
  res.status(200).json({ status: "OK", re: response.data });
});

const ML_API_URL = process.env.ML_API_URL;
if (!ML_API_URL) {
  console.error("ML_API_URL is not defined in environment variables");
  process.exit(1);
}

const PORT = process.env.PORT || 5000;

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
