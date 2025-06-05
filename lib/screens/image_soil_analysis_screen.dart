import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../controllers/soil_controller.dart';
import '../controllers/user_controller.dart';
import 'report_screen.dart';

class ImageSoilAnalysisScreen extends StatelessWidget {
  final SoilController controller = Get.put(SoilController());
  final UserController userController = Get.find();

  ImageSoilAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //screen title and back icon
                Text(
                  "soil_analysis_title".tr,
                  style: TextStyle(
                    color: Color(0xFF116567),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Icon(Icons.more_vert, color: Color(0xFF116567), size: 28),
              ],
            ),
            const Divider(color: Colors.grey, thickness: 1),
            SizedBox(height: 5),
            // Image Preview Section
            Obx(() => _buildImagePreview()),
            const SizedBox(height: 5),

            // Prediction Results
            Obx(() => _buildPredictionResult()),
            const SizedBox(height: 10),

            // Action Buttons
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    return controller.imagePath.isEmpty
        ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.image_search, size: 60, color: Colors.grey),
              SizedBox(height: 10),
              Text(
                'no_image_selected'.tr,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        )
        : ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(
            File(controller.imagePath.value),
            fit: BoxFit.contain,
          ),
        );
  }

  Widget _buildPredictionResult() {
    if (controller.isLoading.value) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.prediction.isNotEmpty) {
      return Card(
        elevation: 4,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'analysis_result'.tr,
                style: Theme.of(Get.context!).textTheme.titleLarge,
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(
                        'soil_type'.tr,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        controller.prediction.value,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        'probability'.tr,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${(controller.confidence.value * 100).toStringAsFixed(1)}%',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              //soil properties section
              const SizedBox(height: 10),
              // Soil properties section
              Text(
                'weather_info'.tr,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),

              Obx(() {
                if (userController.weather.value == null) {
                  return Text(
                    'no_data_available'.tr,
                    style: TextStyle(color: Colors.red),
                  );
                }
                final weather = userController.weather.value!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDataRow(
                      "rainfall".tr,
                      weather.rainfallPerSeason.toStringAsFixed(2),
                      "rainfall_per_season".tr,
                    ),
                    _buildDataRow(
                      "humidity_t".tr,
                      weather.averageHumidity.toStringAsFixed(2),
                      "humidity".tr,
                    ),
                    _buildDataRow(
                      "temperature".tr,
                      weather.averageTemperature.toStringAsFixed(2),
                      "temperature".tr,
                    ),
                  ],
                );
              }),

              const SizedBox(height: 10),
              Center(
                child:
                ElevatedButton(
                  onPressed: () async {
                    await controller.cropRecommendations();
                    Get.to(() => ReportScreen());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF3282B8),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "report".tr,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          icon: const Icon(Icons.photo_library),
          label: Text('gallery'.tr),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          onPressed: () => _pickImage(ImageSource.gallery),
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.camera_alt),
          label: Text('camera'.tr),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          onPressed: () => _pickImage(ImageSource.camera),
        ),
      ],
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      controller.imagePath.value = pickedFile.path;
      await controller.processImage(File(pickedFile.path));
    }
  }

  // Table Row for Weather
  Widget _buildDataRow(String label, String value, String subLabel) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(
                subLabel,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
