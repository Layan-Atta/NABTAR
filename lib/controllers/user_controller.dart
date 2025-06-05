import 'package:get/get.dart';
import '../API/weather_services.dart';
import '../controllers/auth_controller.dart';
import '../models/user_model.dart';
import '../models/weather_model.dart';

class UserController extends GetxController {
  final WeatherService weatherService = WeatherService();
  var weather = Rx<Weather?>(null);
  final AuthController authController = Get.find();
  var isLoading = false.obs; // Loading state
  var user =
      UserModel(
        id: '',
        fullName: '',
        email: '',
        phone: '',
        location: '',
        password: '',
      ).obs;

  @override
  void onInit() {
    super.onInit();
    loadUser();
  }

  Future<void> loadUser() async {
    isLoading.value = true; // Start loading
    UserModel? savedUser = await authController.getSavedUser();
    if (savedUser != null) {
      user.value = savedUser;
    } else {
      if (authController.auth.currentUser != null) {
        String? userId = authController.auth.currentUser?.uid;
        if (userId != null) {
          await authController.firestore
              .collection('users')
              .doc(userId)
              .get()
              .then((doc) {
                if (doc.exists) {
                  user.value = UserModel.fromJson(
                    doc.data() as Map<String, dynamic>,
                  );
                }
              });
        }
      }
    }
    if (weather.value == null) {
      await fetchWeather();
    }

    isLoading.value = false; // Stop loading
  }

  //get weather data from API based current user location
  Future<void> fetchWeather() async {
    //get user location
    String location = user.value.location;
    print('location: $location');
    Map<String, dynamic> data = await weatherService.getWeatherByCity(location);
    weather.value = Weather.fromJson(data);
  }

  logout() {
    authController.logout();
  }
}
