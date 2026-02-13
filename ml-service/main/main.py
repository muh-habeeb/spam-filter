from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import joblib

app = FastAPI()
modelPath="../training/model.pkl"
vectorizerPath="../training/vectorizer.pkl"

try:
    model = joblib.load(modelPath)
    vectorizer = joblib.load(vectorizerPath)
except:
    raise RuntimeError("Model files not found. Train first.  msg from main.py")

class Message(BaseModel):
    text: str

@app.post("/predict")
def predict(message: Message):
    if not message.text.strip():
        raise HTTPException(status_code=400, detail="Message cannot be empty")

    text_vector = vectorizer.transform([message.text])
    prediction = model.predict(text_vector)[0]
    probability = model.predict_proba(text_vector)[0][prediction]

    return {
        "message": message.text,
        "spam": bool(prediction),
        "confidence": round(float(probability), 3)
    }


@app.get("/")
def get_root():
    return {"message": "Spam Filter API is running. Use POST /predict to classify messages."}



if __name__ == "__main__":
    import uvicorn
    import os
    
    port = int(os.getenv("PORT", 8000))
    
    uvicorn.run("main:app", host="0.0.0.0", port=port)