import express, { urlencoded } from 'express';
import cors from "cors";
import dotenv from "dotenv";
import predict from "./controller/predict.controller.js";
import axios from 'axios';
dotenv.config();


const app = express();

app.use(cors());
app.use(express.json(urlencoded({ extended: true })));

app.use("/api/predict", predict);

app.get("/",async (req, res) => {
    const response = await axios.get("http://localhost:8000/")
    res.status(200).json({ status: "OK",re:response.data });
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