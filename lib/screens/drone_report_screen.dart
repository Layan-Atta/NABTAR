import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nabtar_app/controllers/drone_controller.dart';

import '../controllers/language_controller.dart';
import '../utils/app_bar_widget.dart';
import '../utils/carved_shape.dart';

class DroneReportScreen extends StatelessWidget {
  DroneReportScreen({super.key});
  final RxInt selectedTab = 0.obs; // GetX for tab switching
  final LanguageController langController = Get.find();
  final DroneController dronC = Get.find();
  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
      backgroundColor: const Color(0xFF116567), // Background color
      body: SafeArea(
        child: Stack(
          clipBehavior: Clip.none, // Allow overflow for the card
          alignment: Alignment.topCenter,
          fit: StackFit.passthrough,
          children: [
            // Background Header
            Positioned(
              top: 0,
              left: 10,
              right: 10,
              child: Container(
                height: 300,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/header.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 50), // Top padding (for status bar)
                    appBarWidget(
                      langController: langController,
                    ), // Your app bar widget
                  ],
                ),
              ),
            ),

            // Report Card (Overlapping the header)
            Positioned(
              top: 120,
              left: 20,
              right: 20,
              bottom: 10,
              child: ClipPath(
                clipper: CarvedShape(), // Apply the carved shape
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/report.png"),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //screen title and back icon
                              IconButton(
                                icon: Icon(
                                  Icons.arrow_back_ios_rounded,
                                  color: Color(0xFF116567),
                                  size: 28,
                                ),
                                onPressed: () {
                                  Get.back();
                                },
                              ),
                              Text(
                                "report_drone".tr,
                                style: TextStyle(
                                  color: Color(0xFF116567),
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Icon(
                                Icons.more_vert,
                                color: Color(0xFF116567),
                                size: 28,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 10.0,
                            right: 10.0,
                            bottom: 20.0,
                          ),
                          child: Card(
                            elevation: 7,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Title & Progress Indicator
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "scan_report".tr,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const CircularPercentIndicator(
                                        percentage: 60,
                                      ),
                                    ],
                                  ),
                                  //divider
                                  const Text(
                                    "Soil Quality: HIGH",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  const Divider(
                                    color: Colors.grey,
                                    thickness: 1,
                                  ),
                                  const SizedBox(height: 5),

                                  // Tabs: "Soil Analysis" & "Recommended Crops"
                                  Obx(
                                    () => Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          onTap: () => selectedTab.value = 0,
                                          child: Text(
                                            "soil_analysis".tr,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  selectedTab.value == 0
                                                      ? Colors.blue
                                                      : Colors.grey[300],
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () => selectedTab.value = 1,
                                          child: Text(
                                            "recommended_crops".tr,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  selectedTab.value == 1
                                                      ? Colors.blue
                                                      : Colors.grey[300],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  // Dynamic Content Based on Selected Tab
                                  Obx(
                                    () =>
                                        selectedTab.value == 0
                                            ? _soilAnalysisView()
                                            : _recommendedCropsView(),
                                  ),

                                  const SizedBox(height: 15),

                                  // Conclude Button
                                  Center(
                                    child: ElevatedButton.icon(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.check_circle,
                                        color: Colors.white,
                                      ),
                                      label: const Text("CONCLUDE"),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 40,
                                          vertical: 12,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 5),
                                  Text("scan_date".tr),

                                  // Scan Date Section
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.calendar_today,
                                        size: 16,
                                        color: Colors.blue,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        DateFormat.yMMMMd().format(dronC.selectedDate.value),
                                        style: const TextStyle(color: Colors.blue),
                                      ),
                                    ],
                                  ),

                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Soil Analysis View
  Widget _soilAnalysisView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSoilDataRow("rainfall".tr, "202.93", "rainfall_per_season".tr),
        _buildSoilDataRow("PH", "6.50", "ph".tr),
        _buildSoilDataRow("Humidity", "82.00", "humidity".tr),
        _buildSoilDataRow("Temperature", "20.87", "temperature".tr),
        _buildSoilDataRow("N", "90", "nitrogen".tr),
        _buildSoilDataRow("P", "70", "phosphorus".tr),
        _buildSoilDataRow("K", "43", "potassium".tr),

      ],
    );
  }

  // Recommended Crops View
  Widget _recommendedCropsView() {
    List<String> crops = ["Rice", "Maize", "Dates", "Beans", "Strawberry"];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          crops
              .map(
                (crop) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    crop,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              )
              .toList(),
    );
  }

  // Table Row for Soil Properties
  Widget _buildSoilDataRow(String label, String value, String subLabel) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
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

// Circular Percentage Indicator Widget
class CircularPercentIndicator extends StatelessWidget {
  final double percentage;
  const CircularPercentIndicator({required this.percentage, super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 50,
          width: 50,
          child: CircularProgressIndicator(
            value: percentage / 100,
            backgroundColor: Colors.grey.shade300,
            color: Colors.blue,
            strokeWidth: 5,
          ),
        ),
        Text(
          "$percentage%",
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
