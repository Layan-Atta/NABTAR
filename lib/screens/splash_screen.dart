import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../models/user_model.dart';
import 'auth_screen.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), checkAutoLogin);
  }

  Future<void> checkAutoLogin() async {
    final AuthController authController = Get.find();
    UserModel? userData = await authController.getSavedUser();

    if (userData != null) {
      // Navigate to Home Screen if user data exists
      Get.off(() => HomeScreen());
    } else {
      // Navigate to Auth Screen if no user data
      Get.off(() => AuthScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF003D38), // Match the background
      body: Center(
        child: Image.asset('assets/images/splash.png', fit: BoxFit.contain),
      ),
    );
  }
}
