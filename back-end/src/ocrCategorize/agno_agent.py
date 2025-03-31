import os
from flask import Flask, request, jsonify
import json
import google.generativeai as genai
from dotenv import load_dotenv
import dateparser

load_dotenv()

app = Flask(__name__)

class GeminiBillExtractionTool:
    def __init__(self):
        api_key = "AIzaSyDzlwYV-9mLtar4ExXSfaEvq_aBwqs64nQ"
        if not api_key:
            raise ValueError("Missing GEMINI_API_KEY in environment variables")

        genai.configure(api_key=api_key)
        self.model = genai.GenerativeModel("models/gemini-1.5-pro-latest")

    def run(self, bill_text):
        prompt = f"""
            Extract the item details, categorize them, and extract the bill date from this bill text:

            {bill_text}

            Categories: Food, Electronics, Transport, Bills, Clothes, Phone, Sport, Education, Medical, Beauty, Grocery, Vehicle

            Expected JSON Output:
            {{
              "items": [
                {{
                  "item": "MENS PANT MOOSE (36) #M100 976001755",
                  "quantity": 1,
                  "price": 3490.00,
                  "category": "Clothes",
                  "billdate": "2025-03-10"
                }},
                {{
                    "item": "Apple Iphone 15",
                    "quantity": 1,
                    "price": 100000.00,
                    "category": "Phone",
                    "billdate": "2025-10-10"
                }}
              ],
              "billdate": "2025-03-10"  
            }}
        """

        try:
            response = self.model.generate_content(prompt)
            extracted_text = response.text.strip()
            print("Extracted Response:", extracted_text)  # Debugging output

            if extracted_text.startswith("```json"):
                extracted_text = extracted_text[7:-3]

            return json.loads(extracted_text)
        except json.JSONDecodeError:
            return {"error": "Invalid JSON format from Gemini API"}
        except Exception as e:
            return {"error": str(e)}

@app.route('/extract-bill', methods=['POST'])
def extract():
    data = request.json
    bill_text = data.get("bill_text", "")

    if not bill_text:
        return jsonify({"error": "No bill text provided"}), 400

    def standardize_date(date_text):
        parsed_date = dateparser.parse(date_text)
        if parsed_date:
            return parsed_date.strftime("%Y-%m-%d")  # Convert to YYYY-MM-DD format
        return "0000-00-00"  # Default format instead of "Unknown"

    try:
        bill_tool = GeminiBillExtractionTool()
        extracted_data = bill_tool.run(bill_text) or {}

        if "error" in extracted_data:
            return jsonify(extracted_data), 500

        items = extracted_data.get("items", [])
        bill_date = standardize_date(extracted_data.get("billdate", "0000-00-00"))

        allowed_categories = ["Food", "Electronics", "Transport", "Bills", "Clothes", "Phone", "Sport", "Education",
                              "Medical", "Beauty", "Grocery", "Vehicle"]

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
                "category": category,
                "billdate": standardize_date(item.get("billdate", bill_date))  # Standardize bill date
            }
            validated_items.append(validated_item)

        return jsonify({"billdate": bill_date, "items": validated_items})

    except Exception as e:
        print("Error:", str(e))  # Debugging output
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(host="0.0.0.0", port=5000, debug=True)