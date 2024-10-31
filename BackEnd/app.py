from flask import Flask, jsonify
import os
import requests

app = Flask(__name__)

@app.route('/')
def home():
    headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Token wxMe9PEf0xzZMtfsFy9OwQM4lMC3H2mC'
    }
    try:
        response = requests.get("https://api.tiqets.com/v2/products", headers=headers)
        response.raise_for_status()  # Check if the request was successful
        data = response.json()  # Convert response to JSON
        return jsonify(data)  # Return the data as a JSON response
    except requests.exceptions.RequestException as e:
        return jsonify({"error": str(e)}), 500  # Return an error message if the request fails

if __name__ == '__main__':
    port = int(os.environ.get("PORT", 5001))
    app.run(host="0.0.0.0", port=port)
