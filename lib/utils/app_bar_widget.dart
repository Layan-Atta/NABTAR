import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/language_controller.dart';
import '../controllers/user_controller.dart';

class appBarWidget extends StatelessWidget {
  appBarWidget({super.key, required this.langController});

  final LanguageController langController;
  final UserController userController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.notifications, color: Colors.white, size: 28),
          TextButton.icon(
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
          Text(
            "${"hello".tr} ${userController.user.value.fullName.isNotEmpty ? userController.user.value.fullName : ""}",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person,
              color: Colors.black,
              size: 30,
            ), // Profile icon
          ),
        ],
      ),
    );
  }
}
