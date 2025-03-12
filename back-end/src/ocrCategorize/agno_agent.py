from flask import Flask, request, jsonify
import json
import google.generativeai as genai

app = Flask(__name__)

class GeminiBillExtractionTool:
    def __init__(self, gemini_api_key):
        genai.configure(api_key="gemini api key")
        self.model = genai.GenerativeModel("models/gemini-1.5-pro-latest")

    def run(self, bill_text):
        prompt = f"""
            Extract the item details from this bill text:

            {bill_text}

            Expected JSON Output:
            {{
              "items": [
                {{
                  "item": "MENS PANT MOOSE (36) #M100 976001755",
                  "quantity": 1,
                  "price": 3490.00
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
        gemini_api_key = "gemini api key"  # Replace with your actual API key
        bill_tool = GeminiBillExtractionTool(gemini_api_key)
        extracted_items = bill_tool.run(bill_text)
        return jsonify({"extracted_items": extracted_items})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(host="0.0.0.0", port=5000, debug=True)