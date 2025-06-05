import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nabtar_app/controllers/drone_controller.dart';

import '../controllers/language_controller.dart';
import 'drone_report_screen.dart';

class DroneScanningScreen extends StatelessWidget {
  final DroneController droneController = Get.find();
  final LanguageController langController = Get.find();
  DroneScanningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    droneController.startScanningProgress();
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                      langController.changeScreenIndex(5);
                    },
                  ),
                  Text(
                    "drone_request".tr,
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
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  'assets/images/drone.png', // use your actual image asset
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStat("150m", "range".tr),
                  _buildStat(
                    "%${(droneController.progress.value * 100).toStringAsFixed(0)}",
                    "progress".tr,
                  ),
                  _buildStat("41°", "temperature".tr),
                ],
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.only(
                  top: 30,
                  left: 20,
                  right: 20,
                  bottom: 30,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    _buildInfoTile(
                      Icons.location_on,
                      "location".tr,
                      droneController.userController.user.value.location,
                    ),
                    SizedBox(height: 15),
                    _buildInfoTile(
                      Icons.calendar_today,
                      "scan_date".tr,
                      DateFormat.yMMMMd().format(
                        droneController.selectedDate.value,
                      ),
                    ),
                    SizedBox(height: 15),
                    _buildInfoTile(
                      Icons.access_time,
                      "status".tr,
                      droneController.status.value,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              droneController.status.value == "Done"
                  ? Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        Get.to(() => DroneReportScreen());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF3282B8),
                        padding: EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "report".tr,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  )
                  : Text(
                    "scanning".tr,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.teal[800],
                    ),
                  ),
              SizedBox(height: 10),
              LinearProgressIndicator(
                value: droneController.progress.value,
                minHeight: 6,
                color: Colors.orange,
                backgroundColor: Colors.grey[300],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF116567),
          ),
        ),
        SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue),
        SizedBox(width: 10),
        Text(
          "$label: ",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
        ),
        Expanded(child: Text(value)),
      ],
    );
  }
}
