import 'package:get/get.dart';
import 'package:nabtar_app/controllers/auth_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController());
  }
}
