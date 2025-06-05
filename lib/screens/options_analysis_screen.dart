import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nabtar_app/controllers/language_controller.dart';



class OptionsAnalysisScreen extends StatelessWidget {
  OptionsAnalysisScreen({super.key});
  final LanguageController languageController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildOptionCard(
            icon: Icons.image,
            title: "analyze_using_image".tr,
            onTap: () {
              languageController.changeScreenIndex(4);
              // Navigate to Image Analysis
            },
          ),
          const SizedBox(height: 20),
          _buildOptionCard(
            icon: Icons.airplanemode_active,
            title: "analyze_using_drone".tr,
            onTap: () {
              languageController.changeScreenIndex(5);
              // Get.to(
              //   () => DroneAnalysisProcessScreen(),
              // ); // Navigate to Drone Analysis
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOptionCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.teal[100],
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: Colors.teal[700]),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
