import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nabtar_app/screens/drone_report_screen.dart';
import 'package:nabtar_app/screens/drone_request_screen.dart';
import 'package:nabtar_app/screens/drone_scanning_screen.dart';
import 'package:nabtar_app/screens/image_soil_analysis_screen.dart';
import 'package:nabtar_app/screens/options_analysis_screen.dart';
import 'package:nabtar_app/screens/user_reports_screen.dart';
import '../controllers/user_controller.dart';

import '../controllers/language_controller.dart';
import '../utils/app_bar_widget.dart';
import '../utils/carved_shape.dart';
import 'home_content.dart';
import 'setting_screen.dart';

class HomeScreen extends StatelessWidget {
  final LanguageController langController = Get.find();
  final userController = Get.put(UserController());
  final List<Widget> _screens = [
    HomeContent(),
    OptionsAnalysisScreen(),
    SettingScreen(),
    UserReportsScreen(),
    ImageSoilAnalysisScreen(),
    DroneRequestScreen(),
    DroneScanningScreen(),


  ];
  HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {

    return Obx(
      () => Scaffold(
        backgroundColor: const Color(0xFF116567), // Background color
        body: SafeArea(
          child:
              userController.isLoading.value == true
                  ? const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(
                          color: Colors.white, // White color
                          strokeWidth: 6, // Make it bigger
                        ),
                        SizedBox(height: 16),
                        Text(
                          "Waiting...",
                          style: TextStyle(
                            fontSize: 18, // Bigger text
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  )
                  : Stack(
                    children: [
                      // HEADER IMAGE AT TOP
                      Positioned(
                        top: 0, // Stick to the top
                        left: 10,
                        right: 10,
                        child: Container(
                          width: double.infinity,
                          height: 320, // Adjust height as needed
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/images/header.png"),
                              fit: BoxFit.cover, // Adjust based on needs
                            ),
                          ),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 50,
                              ), // Top padding (for status bar)
                              appBarWidget(
                                langController: langController,
                              ), // Your app bar widget
                            ],
                          ),
                        ),
                      ),

                      // MAIN CONTENT BELOW HEADER
                      Positioned(
                        top: 120, // Starts just below the header
                        left: 0,
                        right: 0,
                        bottom: 10,
                        child: ClipPath(
                          clipper: CarvedShape(),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Expanded(
                                  child:
                                      _screens[langController
                                          .screenIndex
                                          .value],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
        ),
        bottomNavigationBar: _buildBottomNavigation(),
      ),
    );
  }

  // 1. Top Bar Section

  // 6. Bottom Navigation Bar
  Widget _buildBottomNavigation() {
    return BottomNavigationBar(
      backgroundColor: Colors.teal.shade900,
      selectedItemColor: Colors.amberAccent,
      unselectedItemColor: Colors.white70,
      currentIndex: langController.bottomIndex.value,
      onTap: langController.changeScreenIndex,
      type: BottomNavigationBarType.fixed, // Add this line
      items:  [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'.tr),
        BottomNavigationBarItem(icon: Icon(Icons.model_training), label: 'ml'.tr),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'settings'.tr),
        BottomNavigationBarItem(icon: Icon(Icons.history_edu), label: 'report'.tr),

      ],
    );
  }
}
