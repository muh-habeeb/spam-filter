import pandas as pd
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.naive_bayes import MultinomialNB
import joblib

# Load dataset
df = pd.read_csv("spam.csv", encoding="latin-1")

# Keep only first two columns
df = df.iloc[:, :2]
df.columns = ["label", "message"]

# Convert label to numeric
df["label"] = df["label"].map({"ham": 0, "spam": 1})

# Drop missing values if any
df.dropna(inplace=True)

print("Dataset loaded successfully")
print(df.head())

# Vectorization
vectorizer = TfidfVectorizer(stop_words="english", ngram_range=(1,2))
X = vectorizer.fit_transform(df["message"])
y = df["label"]

# Train model
model = MultinomialNB()
model.fit(X, y)

# Save model + vectorizer
joblib.dump(model, "model.pkl")
joblib.dump(vectorizer, "vectorizer.pkl")

print("Model trained and saved.")
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score, classification_report

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

model = MultinomialNB()
model.fit(X_train, y_train)

preds = model.predict(X_test)

print("Accuracy:", accuracy_score(y_test, preds))
print(classification_report(y_test, preds))