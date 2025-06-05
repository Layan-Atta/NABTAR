from flask import Flask, request, jsonify
#pip install scikit-learn
# pip install pandas
# pip install flask
# pip install numpy
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
        predicted_crop = model.predict(input_data)[0]

        # Get probabilities for each crop
        probabilities = model.predict_proba(input_data)[0]

        # Get crop labels
        crop_classes = model.classes_

        # Map crop names to their probabilities
        probability_dict = dict(zip(crop_classes, probabilities))

        # Sort probabilities in descending order
        sorted_probabilities = dict(sorted(probability_dict.items(), key=lambda item: item[1], reverse=True))

        return jsonify({
            'recommended_crop': predicted_crop,
            'probabilities': sorted_probabilities
        })

    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    #app.run(debug=True)
    app.run(host='0.0.0.0', port=5000, debug=True)
