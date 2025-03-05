import spacy
from spacy.training.example import Example
import random

# Load or create a blank model
try:
    nlp = spacy.load("expense_nlp")  # Load existing model if available
    print("Loaded existing model.")
except OSError:
    nlp = spacy.blank("en")  # Create a new blank model
    print("Creating new model.")

    if "textcat" not in nlp.pipe_names:
        textcat = nlp.add_pipe("textcat", last=True)
    else:
        textcat = nlp.get_pipe("textcat")

# Ensure `textcat` is always defined
if "textcat" not in nlp.pipe_names:
    textcat = nlp.add_pipe("textcat", last=True)
else:
    textcat = nlp.get_pipe("textcat")

# Define expense categories
categories = ["Food", "Electronics", "Transport", "Bills", "Clothes", "Phone",
              "Sport", "Education", "Medical", "Beauty", "Grocery", "Vehicle"]

for category in categories:
    textcat.add_label(category)

# Sample training data
TRAINING_DATA = [
    # grocery
    ("Tomatoes, cucumbers, carrots, and bell peppers", {"cats": {"Grocery": 1.0, "Medical": 0.0}}),
    ("Cabbage, lettuce, and spinach purchase", {"cats": {"Grocery": 1.0, "Medical": 0.0}}),
    ("Cauliflower, broccoli, and asparagus", {"cats": {"Grocery": 1.0, "Medical": 0.0}}),
    ("Eggplant, zucchini, and mushrooms", {"cats": {"Grocery": 1.0, "Medical": 0.0}}),
    ("Sweet potatoes, yams, and beetroots", {"cats": {"Grocery": 1.0, "Medical": 0.0}}),
    ("Garlic, ginger, and shallots", {"cats": {"Grocery": 1.0, "Medical": 0.0}}),
    ("Peas, green beans, and lentils", {"cats": {"Grocery": 1.0, "Medical": 0.0}}),
    ("Radish, turnips, and parsnips", {"cats": {"Grocery": 1.0, "Medical": 0.0}}),
    ("Brussels sprouts, okra, and celery", {"cats": {"Grocery": 1.0, "Medical": 0.0}}),
    ("Pumpkin, squash, and corn", {"cats": {"Grocery": 1.0, "Medical": 0.0}}),
    ("Apples, bananas, and oranges", {"cats": {"Grocery": 1.0, "Medical": 0.0}}),
    ("Strawberries, blueberries, and raspberries", {"cats": {"Grocery": 1.0, "Medical": 0.0}}),
    ("Mangoes, pineapples, and papayas", {"cats": {"Grocery": 1.0, "Medical": 0.0}}),
    ("Grapes, cherries, and pomegranates", {"cats": {"Grocery": 1.0, "Medical": 0.0}}),
    ("Watermelon, cantaloupe, and honeydew melon", {"cats": {"Grocery": 1.0, "Medical": 0.0}}),
    ("Peaches, plums, and apricots", {"cats": {"Grocery": 1.0, "Medical": 0.0}}),
    ("Kiwis, passion fruits, and dragon fruits", {"cats": {"Grocery": 1.0, "Medical": 0.0}}),
    ("Pears, figs, and dates", {"cats": {"Grocery": 1.0, "Medical": 0.0}}),
    ("Lemons, limes, and grapefruit", {"cats": {"Grocery": 1.0, "Medical": 0.0}}),
    ("Coconuts and avocados", {"cats": {"Grocery": 1.0, "Medical": 0.0}}),
    ("Milk, eggs, and milk powder purchase", {"cats": {"Grocery": 1.0, "Medical": 0.0}}),
    ("Cheese, yogurt, and butter", {"cats": {"Grocery": 1.0, "Medical": 0.0}}),
    ("Rice, pasta, and flour bought", {"cats": {"Grocery": 1.0, "Medical": 0.0}}),
    ("Sugar, salt, and spices", {"cats": {"Grocery": 1.0, "Medical": 0.0}}),
    ("Tea, coffee, and juice", {"cats": {"Grocery": 1.0, "Medical": 0.0}}),
    ("Cookies, chips, and chocolates", {"cats": {"Grocery": 1.0, "Medical": 0.0}}),
    ("Ice cream, cake, and pastries", {"cats": {"Grocery": 1.0, "Medical": 0.0}}),
    ("Cleaning supplies and toiletries", {"cats": {"Grocery": 1.0, "Medical": 0.0}}),
    ("Laundry detergent and dish soap", {"cats": {"Grocery": 1.0, "Medical": 0.0}}),
    ("Trash bags and paper towels", {"cats": {"Grocery": 1.0, "Medical": 0.0}}),
    ("Toothpaste, shampoo, and soap", {"cats": {"Grocery": 1.0, "Medical": 0.0}}),
    ("Diapers, wipes, and baby food", {"cats": {"Grocery": 1.0, "Medical": 0.0}}),

    # Food
    ("Pizza and burgers for dinner", {"cats": {"Food": 1.0, "Grocery": 0.0}}),
    ("Chicken biryani and soft drinks", {"cats": {"Food": 1.0, "Grocery": 0.0}}),
    ("Coffee and donuts from cafe", {"cats": {"Food": 1.0, "Grocery": 0.0}}),
    ("Breakfast combo with eggs, toast, and bacon", {"cats": {"Food": 1.0, "Grocery": 0.0}}),
    ("Lunch at a Chinese restaurant", {"cats": {"Food": 1.0, "Grocery": 0.0}}),
    ("Fried rice and spicy noodles", {"cats": {"Food": 1.0, "Grocery": 0.0}}),

    # Medical
    ("Aspirin and cough syrup purchase", {"cats": {"Medical": 1.0, "Grocery": 0.0}}),
    ("Cold medicine and thermometer", {"cats": {"Medical": 1.0, "Grocery": 0.0}}),
    ("Prescription antibiotics and pain relief gel", {"cats": {"Medical": 1.0, "Grocery": 0.0}}),
    ("Multivitamins and fish oil supplements", {"cats": {"Medical": 1.0, "Grocery": 0.0}}),
    ("First aid kit with bandages and antiseptic", {"cats": {"Medical": 1.0, "Grocery": 0.0}}),

    # Sport
    ("Football and a set of jerseys", {"cats": {"Sport": 1.0, "Clothes": 0.0}}),
    ("Tennis racket and tennis balls", {"cats": {"Sport": 1.0, "Clothes": 0.0}}),
    ("Gym membership renewal", {"cats": {"Sport": 1.0, "Clothes": 0.0}}),
    ("Yoga mat and resistance bands", {"cats": {"Sport": 1.0, "Clothes": 0.0}}),

    # Clothes
    ("Nike running shoes", {"cats": {"Clothes": 1.0, "Sport": 0.0}}),
    ("T-shirts and jeans from the mall", {"cats": {"Clothes": 1.0, "Sport": 0.0}}),
    ("Winter jacket and gloves", {"cats": {"Clothes": 1.0, "Sport": 0.0}}),
    ("Formal suit for an event", {"cats": {"Clothes": 1.0, "Sport": 0.0}}),
    ("Running shorts and sportswear", {"cats": {"Clothes": 1.0, "Sport": 0.0}}),

    # Transport
    ("Bus pass for the month", {"cats": {"Transport": 1.0, "Bills": 0.0}}),
    ("Taxi ride to the airport", {"cats": {"Transport": 1.0, "Bills": 0.0}}),
    ("Train ticket to another city", {"cats": {"Transport": 1.0, "Bills": 0.0}}),

    # Education
    ("School textbooks and notebooks", {"cats": {"Education": 1.0, "Grocery": 0.0}}),
    ("Online course subscription", {"cats": {"Education": 1.0, "Grocery": 0.0}}),
    ("Stationery items: pens, pencils, and erasers", {"cats": {"Education": 1.0, "Grocery": 0.0}}),
    ("University tuition fees", {"cats": {"Education": 1.0, "Bills": 0.0}}),

    # Beauty
    ("Face wash and moisturizer", {"cats": {"Beauty": 1.0, "Medical": 0.0}}),
    ("Lipstick and foundation", {"cats": {"Beauty": 1.0, "Medical": 0.0}}),
    ("Shampoo and hair conditioner", {"cats": {"Beauty": 1.0, "Medical": 0.0}}),
    ("Spa and facial treatment", {"cats": {"Beauty": 1.0, "Medical": 0.0}}),

    # Bills
    ("Water bill payment for the month", {"cats": {"Bills": 1.0, "Shopping": 0.0}}),
    ("Mobile phone recharge", {"cats": {"Bills": 1.0, "Phone": 0.0}}),
    ("Electricity bill settlement", {"cats": {"Bills": 1.0, "Shopping": 0.0}}),
    ("Internet service payment", {"cats": {"Bills": 1.0, "Phone": 0.0}}),

    # Vehicle
    ("Car service and engine oil change", {"cats": {"Vehicle": 1.0, "Transport": 0.0}}),
    ("Motorbike servicing and new tires", {"cats": {"Vehicle": 1.0, "Transport": 0.0}}),
    ("Car insurance renewal", {"cats": {"Vehicle": 1.0, "Transport": 0.0}}),
    ("Car wash and detailing", {"cats": {"Vehicle": 1.0, "Transport": 0.0}}),
    ("Motor oil and brake fluid purchase", {"cats": {"Vehicle": 1.0, "Transport": 0.0}}),

    # Electronics
    ("Batteries, light bulbs, and tools", {"cats": {"Electronics": 1.0, "Medical": 0.0}}),
    ("Laptop purchase and accessories", {"cats": {"Electronics": 1.0, "Shopping": 0.0}}),
    ("Smartphone and wireless earbuds", {"cats": {"Electronics": 1.0, "Shopping": 0.0}}),
    ("Gaming console and controllers", {"cats": {"Electronics": 1.0, "Shopping": 0.0}}),
    ("TV and home theater system", {"cats": {"Electronics": 1.0, "Shopping": 0.0}}),
]


# Training the model
n_iter = 10
optimizer = nlp.initialize()  # Corrected training initialization

for i in range(n_iter):
    random.shuffle(TRAINING_DATA)
    losses = {}

    for text, annotations in TRAINING_DATA:
        doc = nlp.make_doc(text)
        example = Example.from_dict(doc, annotations)
        nlp.update([example], losses=losses)

    print(f"Iteration {i+1}, Loss: {losses}")

# Save the trained model
nlp.to_disk("expense_nlp")
print("Model training complete and saved as 'expense_nlp'")
