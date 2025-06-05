from flask import Flask, request, jsonify
import pickle
import pandas as pd

app = Flask(__name__)

# Load the trained model
with open('crop_training_model.pkl', 'rb') as model_file:
    model = pickle.load(model_file)

@app.route('/')
def home():
    return "Crop Recommendation API is running!"

@app.route('/predict', methods=['POST'])
def predict():
    try:
        # Get JSON request data
        data = request.json
        features = ['N', 'P', 'K', 'temperature', 'humidity', 'ph', 'rainfall']

        # Ensure all required features are present
        if not all(f in data for f in features):
            return jsonify({'error': 'Missing one or more input values'}), 400

        # Convert input to DataFrame
        input_data = pd.DataFrame([data], columns=features)

        # Make prediction
        prediction = model.predict(input_data)[0]
        
        return jsonify({'recommended_crop': prediction})

    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    # Run the Flask app
    app.run(host='0.0.0.0', port=5000, debug=True)
