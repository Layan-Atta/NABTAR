import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/report_controller.dart';
import '../controllers/user_controller.dart';
import '../models/report_model.dart';

class UserReportsScreen extends StatelessWidget {
  UserReportsScreen({super.key});

  final ReportController reportC = Get.put(ReportController());
  final UserController userController = Get.find();

  @override
  Widget build(BuildContext context) {
    // Load reports when screen is opened
    reportC.loadReports(userController.user.value.id.toString());

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //screen title and back icon
            Text(
              "my_reports".tr,
              style: TextStyle(
                color: Color(0xFF116567),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const Divider(color: Colors.grey, thickness: 1),
        Obx(() {
          if (reportC.reportList.isEmpty) {
            return const Center(child: Text("No reports found"));
          }
          if (reportC.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return Expanded(
            child: ListView.builder(
              itemCount: reportC.reportList.length,
              itemBuilder: (context, index) {
                final ReportModel report = reportC.reportList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          report.scanDate,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text("📍 ${report.location}"),
                        const SizedBox(height: 6),
                        Text(
                          "🌧️ ${"rainfall".tr}:${report.rainfall.toStringAsFixed(2)} mm",
                        ),
                        Text(
                          "💧 ${"humidity".tr}:${report.humidity.toStringAsFixed(2)} %",
                        ),
                        Text(
                          "🌡️ ${"temperature".tr}: ${report.temperature.toStringAsFixed(2)} °C",
                        ),
                        const Divider(height: 20),
                        Text(
                          "🌿 ${"recommended_crops".tr}:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        ...report.recommendedCrops.map(
                          (crop) => Text("• $crop"),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }),
      ],
    );
  }
}
