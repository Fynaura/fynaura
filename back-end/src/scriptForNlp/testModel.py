import spacy

# Load the trained model
nlp = spacy.load("expense_nlp")

# Test with a sample expense description
test_text = "Bought apples, milk, and bread"

# Process the text
doc = nlp(test_text)

# Print category scores
print("Expense Category Predictions:")
for category, score in doc.cats.items():
    print(f"{category}: {score:.4f}")
