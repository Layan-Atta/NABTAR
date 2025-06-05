import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nabtar_app/screens/forgot_password_screen.dart';

import '../controllers/auth_controller.dart';
import '../controllers/language_controller.dart';
import '../models/user_model.dart';
import '../utils/carved_shape.dart';
import 'home_screen.dart';

class AuthScreen extends StatelessWidget {
  final LanguageController langController = Get.find();
  final AuthController authController = Get.find();
  //fullname input
  final TextEditingController fullname = TextEditingController();
  //email input
  final TextEditingController email = TextEditingController();
  //password input
  final TextEditingController password = TextEditingController();
  //phone input
  final TextEditingController phone = TextEditingController();
  //location input
 // final TextEditingController location = TextEditingController();
  // List of cities in Saudi Arabia
  final List<String> saudiCities = [
    "Riyadh",
    "Jeddah",
    "Mecca",
    "Medina",
    "Dammam",
    "Khobar",
    "Abha",
    "Tabuk",
    "Buraydah",
    "Hofuf",
    "Najran",
    "Hail",
    "Jubail",
    "Yanbu",
  ];

  // Selected location
  final RxString selectedLocation = "Riyadh".obs;
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
              // _buildBackground(),
              Obx(
                () =>
                    authController.isLogin.value
                        ? _buildLoginForm()
                        : _buildSignupForm(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return _buildAuthCard(
      title: "login_title".tr,
      subtitle: "login_desc".tr,
      isLogin: true,
    );
  }

  Widget _buildSignupForm() {
    return _buildAuthCard(
      title: "register_title".tr,
      subtitle: "register_desc".tr,
      isLogin: false,
    );
  }

  Widget _buildAuthCard({
    required String title,
    required String subtitle,
    required bool isLogin,
  }) {
    return Center(
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
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
                const SizedBox(height: 20),
                _buildAuthFields(isLogin),
                const SizedBox(height: 10),
                _buildActionButton(isLogin),
                const SizedBox(height: 10),
                _buildToggleAuthMode(isLogin),
                const SizedBox(height: 10),
                authController.isLogin.value
                    ? _buildSocialButtons()
                    : SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAuthFields(bool isLogin) {
    return Column(
      children: [
        if (!isLogin)
          _buildTextField(
            "full_name".tr,
            Icons.person,
            controller: fullname,
            keyboardType: TextInputType.name,
          ),
        _buildTextField(
          "email".tr,
          Icons.email,
          controller: email,
          keyboardType: TextInputType.emailAddress,
        ),
        _buildTextField(
          "password".tr,
          Icons.lock,
          isPassword: true,
          controller: password,
        ),
        if (!isLogin)
          _buildTextField(
            "phone".tr,
            Icons.phone,
            controller: phone,
            keyboardType: TextInputType.phone,
          ),
        // if (!isLogin)
        //   _buildTextField(
        //     "location".tr,
        //     Icons.location_on,
        //     controller: location,
        //     keyboardType: TextInputType.streetAddress,
        //   ),
        if (!isLogin) _buildLocationDropdown(),
        if (isLogin) _buildRememberMe(),
      ],
    );
  }
  Widget _buildLocationDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Obx(
            () => DropdownButtonFormField<String>(
          value: selectedLocation.value,
          items: saudiCities.map((city) {
            return DropdownMenuItem(
              value: city,
              child: Text(city),
            );
          }).toList(),
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.location_on, color: Colors.blueAccent.shade100),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          ),
          onChanged: (value) {
            if (value != null) {
              selectedLocation.value = value;
            }
          },
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

  Widget _buildRememberMe() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Obx(
              () => Checkbox(
                value: authController.isRememberMeChecked.value,
                onChanged: (value) {
                  authController.toggleRememberMe(value);
                },
              ),
            ),
            Text("remember_me".tr),
          ],
        ),
        TextButton(
          onPressed: () {
            Get.to(()=>ForgotPasswordScreen());
          },
          child: Text(
            "forgot_password".tr,
            style: const TextStyle(
              color: Colors.blueAccent,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(bool isLogin) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: () async {
          if (isLogin) {
            await validationLogin();
            //Get.to(() => HomeScreen());
          } else {
            //form validations
            await validationSignup();
          }
        },
        child: Obx(() {
          // Observe the loading state from GetX controller
          if (authController.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            );
          } else {
            return Text(
              isLogin ? "login".tr : "register".tr,
              style: const TextStyle(fontSize: 16),
            );
          }
        }),
      ),
    );
  }

  Widget _buildToggleAuthMode(bool isLogin) {
    return TextButton(
      onPressed: authController.toggleAuthMode,
      child: Text(
        isLogin ? "not_have_an_account".tr : "already_have_an_account".tr,
      ),
    );
  }

  Widget _buildSocialButtons() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider(thickness: 1, color: Colors.grey.shade300)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text("or_login_with".tr, style: TextStyle(fontSize: 14)),
            ),
            Expanded(child: Divider(thickness: 1, color: Colors.grey.shade300)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              onPressed: () {},
              icon: Image.asset("assets/images/google.png", width: 20),
              label: Text("google".tr),
            ),
          ],
        ),
      ],
    );
  }

  //when click on Register button call this method
  validationSignup() async {
    if (fullname.text.isEmpty ||
        email.text.isEmpty ||
        password.text.isEmpty ||
        phone.text.isEmpty ||
        selectedLocation.value.isEmpty) {
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
    }
    //check password length
    if (password.text.length < 6) {
      //show snackbar with error message
      Get.snackbar(
        "error".tr,
        "password_length".tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    } else {
      UserModel newUser = UserModel(
        fullName: fullname.text,
        email: email.text,
        password: password.text,
        phone: phone.text,
        location: selectedLocation.value,
        id: "",
      );
      String? authResult = await authController.signUpUser(newUser);
      if (authResult == "signup_success".tr) {
        Get.snackbar(
          "success".tr,
          "signup_success".tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        email.clear();
        password.clear();
        fullname.clear();
        phone.clear();
        authController.toggleAuthMode();
      } else {
        Get.snackbar(
          "error".tr,
          authResult!,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  validationLogin() async {
    if (email.text.isEmpty || password.text.isEmpty) {
      //show snackbar with error message
      Get.snackbar(
        "error".tr,
        "please_fill_all_fields".tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    } else {
      String? result = await authController.loginUser(
        email.text,
        password.text,
      );
      if (result == "login_success".tr) {
        Get.snackbar(
          "success".tr,
          "login_success".tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        email.clear();
        password.clear();
        Get.to(() => HomeScreen());
      } else {
        Get.snackbar(
          "error".tr,
          result!,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }
}
