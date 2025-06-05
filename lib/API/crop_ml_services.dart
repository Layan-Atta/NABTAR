import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/crop_model.dart';


class CropMlServices {
  static const String baseUrl =
      "http://192.168.63.38:5000"; // Change this for production

  // Function to send data to API and get crop recommendation
  static Future<CropPrediction?> getCropRecommendation(Map<String, dynamic> inputData) async {
    final url = Uri.parse("$baseUrl/predict");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(inputData),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return CropPrediction.fromJson(responseData);
      } else {
        print("Error: ${response.body}");
        return null;
      }
    } catch (e) {
      print("API Error: $e");
      return null;
    }
  }
}

/*
N
Nitrogen Level

P
Phosphorus Level

K
Potassium Level

temperature
Temperature


humidity
Local Humidity


ph
PH of soil


rainfall
Rainfall During the season


label
Crop Suitable
 */
/*
soil = {
    "Alluvial soil": "{This soil is suitable for crops: Rice, SugarCane, Maize, Cotton, Soyabean, Jute}",
    "Black Soil": "{This soil is suitable for crops: Wheat, Virginia, Jowar, Millets, Linseed, Castor, Sunflower}",
    "Clay soil": "{This soil is suitable for crops: Rice, Lettuce, Chard, Broccoli, Cabbage, Snap, Beans}",
    "Red soil": "{This soil is suitable for crops: Cotton, Pulses, Millets, OilSeeds, Potatoes}",
}
 */
/*
# Define season start and end dates
    seasons = {
        "winter": ("2023-12-01", "2024-02-28"),
        "spring": ("2024-03-01", "2024-05-31"),
        "summer": ("2024-06-01", "2024-08-31"),
        "fall": ("2024-09-01", "2024-11-30")
    }
 */