import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../controllers/language_controller.dart';
import '../utils/carved_shape.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final LanguageController langController = Get.find();
  final AuthController authController = Get.find();
  //email input
  final TextEditingController email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF005F59),
              Color(0xFF093A3E),
            ], // Dark greenish-blue gradient
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            foregroundColor: Colors.white,
            backgroundColor: Colors.transparent,
            title: TextButton.icon(
              icon: const Icon(Icons.language, color: Colors.white),
              onPressed: () {
                String newLang =
                    langController.currentLocale.value == 'en' ? 'ar' : 'en';
                langController.changeLanguage(newLang);
              },
              label: Text(
                langController.currentLocale.value
                    .toUpperCase(), // Displays "EN" or "AR"
                style: const TextStyle(color: Colors.white),
              ),
            ),
            centerTitle: true,
          ),
          body: Stack(
            children: [
              Center(
                child: SingleChildScrollView(
                  child: ClipPath(
                    clipper: CarvedShape(), // Apply the carved shape
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(20),
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
                          Text(
                            "forgot_title".tr,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "forgot_sub".tr,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildTextField(
                            "email".tr,
                            Icons.email,
                            controller: email,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              onPressed: () async {
                                await validationReset();
                              },
                              child: Obx(() {
                                // Observe the loading state from GetX controller
                                if (authController.isLoading.value) {
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  );
                                } else {
                                  return Text(
                                    "reset_password".tr,
                                    style: const TextStyle(fontSize: 16),
                                  );
                                }
                              }),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String hint,
    IconData icon, {
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.blueAccent.shade100),
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }

  //when click on Register button call this method
  validationReset() async {
    if (email.text.isEmpty) {
      //show snackbar with error message
      Get.snackbar(
        "error".tr,
        "please_fill_all_fields".tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    //check email pattern is true
    if (!GetUtils.isEmail(email.text)) {
      //show snackbar with error message
      Get.snackbar(
        "error".tr,
        "please_enter_valid_email".tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    } else {
      //call signup method from auth controller
      String result = await authController.resetPassword(email.text);
      if (result=="reset_link_sent_successfully".tr) {
        //show snackbar with success message
        Get.snackbar(
          "success".tr,
          result,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
      else{
        //show snackbar with error message
        Get.snackbar(
          "error".tr,
          result,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }

    }
  }
}
