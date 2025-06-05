import 'package:get/get.dart';
import 'package:nabtar_app/controllers/language_controller.dart';
import 'package:nabtar_app/controllers/user_controller.dart';
import 'dart:async';

class DroneController extends GetxController {
  final UserController userController = Get.find();
  final LanguageController languageController= Get.find();

  var recommendedCrop = ''.obs;
  var isLoading = false.obs;
  var selectedDate = DateTime.now().obs;
  var stepIndex = 0.obs;

  var progress = 0.0.obs;
  var status = "Scanning".obs;

  void updateDate(DateTime newDate) {
    selectedDate.value = newDate;
  }

  void nextStep() {
    if (stepIndex.value <= 2) {
      stepIndex.value++;
    }
    if (stepIndex.value > 2) {
      languageController.changeScreenIndex(6);
    }
  }

  void startScanningProgress() {
    progress.value = 0.0;
    status.value = "Scanning";
    Timer.periodic(Duration(milliseconds: 300), (timer) {
      if (progress.value < 1.0) {
        progress.value += 0.1;
      } else {
        progress.value = 1.0;
        status.value = "Done";
        timer.cancel();

        // Navigate to report screen when done
       // Get.to(() => DronReport());
      }
    });
  }
}
