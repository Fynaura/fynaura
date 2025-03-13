import os
from flask import Flask, request, jsonify
import json
import google.generativeai as genai

app = Flask(__name__)

class GeminiBillExtractionTool:
    def __init__(self):  
        genai.configure(api_key="Google api key")  
        self.model = genai.GenerativeModel("models/gemini-1.5-pro-latest")

    def run(self, bill_text):
        prompt = f"""
            Extract the item details and categorize them from this bill text:

            {bill_text}

            Categories: Food, Electronics, Transport, Bills, Clothes, Phone, Sport, Education, Medical, Beauty, Grocery, Vehicle

            Expected JSON Output:
            {{
              "items": [
                {{
                  "item": "MENS PANT MOOSE (36) #M100 976001755",
                  "quantity": 1,
                  "price": 3490.00,
                  "category": "Clothes"
                }},
                {{
                    "item": "Apple Iphone 15",
                    "quantity": 1,
                    "price": 100000.00,
                    "category": "Phone"
                }}
              ]
            }}
        """

        try:
            response = self.model.generate_content(prompt)
            extracted_text = response.text.strip()

            if extracted_text.startswith("```json"):
                extracted_text = extracted_text[7:-3]

            return json.loads(extracted_text)
        except Exception as e:
            return {"error": str(e)}

@app.route('/extract-bill', methods=['POST'])
def extract():
    data = request.json
    bill_text = data.get("bill_text", "")

    if not bill_text:
        return jsonify({"error": "No bill text provided"}), 400

    try:
        bill_tool = GeminiBillExtractionTool() 
        extracted_data = bill_tool.run(bill_text)

        if "error" in extracted_data:
            return jsonify(extracted_data), 500

        items = extracted_data.get("items", [])

        allowed_categories = ["Food", "Electronics", "Transport", "Bills", "Clothes", "Phone", "Sport", "Education", "Medical", "Beauty", "Grocery", "Vehicle"]

        # Validate and format extracted items
        validated_items = []
        for item in items:
            category = item.get("category", "Uncategorized")
            if category not in allowed_categories:
                category = "Uncategorized"

            validated_item = {
                "item": item.get("item", "Item name not found"),
                "quantity": int(item.get("quantity", 0)),
                "price": float(item.get("price", 0.0)),
                "category": category
            }
            validated_items.append(validated_item)

        return jsonify({"items": validated_items})

    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(host="0.0.0.0", port=5000, debug=True)