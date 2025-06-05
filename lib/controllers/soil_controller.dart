import 'dart:io';
import 'package:get/get.dart';
import 'package:nabtar_app/controllers/user_controller.dart';
import 'package:nabtar_app/models/soil_properties_model.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

import '../API/crop_ml_services.dart';
import '../models/crop_model.dart';
import '../screens/report_screen.dart';

class SoilController extends GetxController {
  final List<String> soilTypes = [
    'Alluvial soil',
    'Black Soil',
    'Clay soil',
    'Red soil',
  ];
  var soilProperties = Rx<SoilProperties?>(null);
  final UserController userController = Get.find();

  late Interpreter _interpreter;
  var isLoading = false.obs;
  var imagePath = ''.obs;
  var prediction = ''.obs;
  var confidence = 0.0.obs;

  var top3Crops = <String>[].obs; // Observable list for top 3 crops

  @override
  void onInit() {
    super.onInit();
    _loadModel();
    //fetchWeather();
  }

  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset(
        'assets/soil_classifierls.tflite',
      );
      print('Model loaded successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to load model: $e');
    }
  }

  Future<void> processImage(File image) async {
    isLoading(true);
    try {
      // Get tensor information
      final inputTensor = _interpreter.getInputTensors().first;
      final outputTensor = _interpreter.getOutputTensors().first;
      // Preprocess image with explicit typing
      final inputBuffer = await _preprocessImage(image, inputTensor.shape);
      // Initialize output buffer with proper dimensions
      final outputShape = outputTensor.shape;
      final outputBuffer = List.generate(
        outputShape[0],
        (_) => List<double>.filled(outputShape[1], 0.0),
      );
      // Run inference
      _interpreter.run(inputBuffer, outputBuffer);

      // Process results with explicit typing
      final results = outputBuffer[0].cast<double>();
      final maxConfidence = results.reduce((a, b) => a > b ? a : b);
      final index = results.indexOf(maxConfidence);

      prediction(soilTypes[index]);
      confidence(maxConfidence);
      // Fetch soil properties for the predicted soil
      soilProperties.value = getSoilProperties(soilTypes[index]);
      print('soilProperties: ${soilProperties.toJson()}');
    } catch (e) {
      Get.snackbar('Error', 'Prediction failed: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<List<List<List<List<double>>>>> _preprocessImage(
    File imageFile,
    List<int> shape,
  ) async {
    final imageBytes = await imageFile.readAsBytes();
    final image = img.decodeImage(imageBytes)!;
    final resized = img.copyResize(image, width: 64, height: 64);

    // Explicitly typed preprocessing
    return [
      List.generate(
        64,
        (y) => List.generate(64, (x) {
          final pixel = resized.getPixel(x, y);
          return [
            pixel.b.toDouble() / 255.0,
            pixel.g.toDouble() / 255.0,
            pixel.r.toDouble() / 255.0,
          ];
        }),
      ),
    ];
  }

  // Fetch a specific soil's properties
  SoilProperties getSoilProperties(String soilType) {
    final Map<String, dynamic> soilData = {
      'Alluvial soil': {'N': 110, 'P': 55, 'K': 150, 'ph': 6.2},
      'Black Soil': {'N': 90, 'P': 40, 'K': 150, 'ph': 8.5},
      'Clay soil': {'N': 100, 'P': 50, 'K': 70, 'ph': 7.5},
      'Red soil': {'N': 25, 'P': 35, 'K': 45, 'ph': 6.0},
    };

    final data = soilData[soilType] ?? {'N': 0, 'P': 0, 'K': 0, 'ph': 0};
    return SoilProperties.fromJson({...data, 'soil': soilType});
  }

  /// functions to use CropMlServices class for( crop recommendation model)
  cropRecommendations() async {
    final soil = soilProperties.value;
    if (soil == null) {
      Get.snackbar('Error', 'Soil properties not available');
      return;
    }
    //features = ['N', 'P', 'K', 'temperature', 'humidity', 'ph', 'rainfall']
    final input = {
      'N': soil!.nitrogen,
      'P': soil.phosphorus,
      'K': soil.potassium,
      'temperature': userController.weather.value!.averageTemperature,
      'humidity': userController.weather.value!.averageHumidity,
      'ph': soil.ph,
      'rainfall': userController.weather.value!.rainfallPerSeason,
    };

    // Call crop recommendation model
    CropPrediction? cropPrediction = await CropMlServices.getCropRecommendation(
      input,
    );
    print(cropPrediction!.recommendedCrop);
    // Sort probabilities in descending order
    List<MapEntry<String, double>> sortedEntries =
        cropPrediction!.probabilities.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

    // Extract top 3 crops with probability >= 20%
    List<String> top3 =
        sortedEntries
            .take(3) // Take only the top 3
            .map((entry) => entry.key)
            .toList();
    print("top3: $top3");
    top3Crops.assignAll(top3);
    //go to report screen
    Get.to(() => ReportScreen());
  }

  @override
  void onClose() {
    _interpreter.close();
    super.onClose();
  }
}
