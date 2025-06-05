import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nabtar_app/screens/splash_screen.dart';
import 'package:nabtar_app/utils/binding.dart';
import 'package:nabtar_app/utils/localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:nabtar_app/controllers/language_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final LanguageController langController = Get.put(LanguageController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GetMaterialApp(
        initialBinding: InitialBinding(),
        debugShowCheckedModeBanner: false,
        title: 'Nabtar App',
        translations: AppTranslations(),
        locale: Locale(langController.currentLocale.value),
        fallbackLocale: Locale('en'),
        theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.blue,
          //choose font suite for arabic and english
          fontFamily:
              langController.currentLocale.value == 'ar'
                  ? 'Tajawal'
                  : 'Montserrat',
        ),
        darkTheme: ThemeData(brightness: Brightness.dark),

        home: Directionality(
          textDirection:
              langController.currentLocale.value == 'ar'
                  ? TextDirection.rtl
                  : TextDirection.ltr,
          child: SplashScreen(),
        ),
      ),
    );
  }
}
