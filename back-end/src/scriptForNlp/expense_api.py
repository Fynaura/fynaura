from fastapi import FastAPI
import spacy

app = FastAPI()

# Load the trained model
nlp = spacy.load("expense_nlp")


@app.get("/")
def home():
    return {"message": "Expense Classification API is running!"}


@app.post("/predict/")
def predict_expense(text: str):
    doc = nlp(text)
    categories = {category: float(score) for category, score in doc.cats.items()}
    predicted_category = max(categories, key=categories.get)

    return {
        "text": text,
        "predicted_category": predicted_category,
        "scores": categories
    }
