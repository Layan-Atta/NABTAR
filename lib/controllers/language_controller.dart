import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:nabtar_app/controllers/auth_controller.dart';
import 'package:nabtar_app/screens/auth_screen.dart';

class LanguageController extends GetxController {
  var currentLocale = 'en'.obs; // Default Language is English
  var screenIndex = 0.obs;
  var bottomIndex = 0.obs;

  void changeLanguage(String langCode) {
    currentLocale.value = langCode;
    Get.updateLocale(Locale(langCode));
  }

  void changeScreenIndex(int index) {
    if (index <= 3) {
      bottomIndex.value = index;
    }

    screenIndex.value = index;
  }

  //drone request pages
}
