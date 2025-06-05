import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nabtar_app/controllers/user_controller.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/language_controller.dart';

class HomeContent extends StatelessWidget {
  HomeContent({super.key});
  final LanguageController langController = Get.find();
  final UserController userController = Get.find();

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        const SizedBox(height: 10),
        _buildWeatherCard(context),
        const SizedBox(height: 15),
        _buildDroneRequestCard(),
        const SizedBox(height: 20),
        _buildArticlesSection(),
        SizedBox(height: 30),
        //more info about nab tar app
        _buildMoreInfoCard(),
      ],
    );
  }

  Widget _buildWeatherCard(BuildContext context) {
    final weather = userController.weather.value;
    // If storm is coming, show alert
    if (weather!.description.toLowerCase().contains("storm")) {
      Future.delayed(Duration.zero, () => _showStormAlert(context));
    }
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.blueGrey[200],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wb_sunny, color: Colors.white, size: 24),
          SizedBox(width: 5),
          Expanded(
            // Ensure text can wrap within available space
            child: Text(
              "${"weather".tr} ${weather!.location} ${weather.description}/${weather.temperature.toStringAsFixed(2)}°C",
              maxLines: 3,
              overflow: TextOverflow.visible,
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  //3. Drone Request Section
  Widget _buildDroneRequestCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            padding: EdgeInsets.only(left: 10, top: 30, bottom: 20, right: 10),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                Text(
                  "drone_title".tr,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "drone_desc".tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    langController.changeScreenIndex(1);
                    // Get.to(() => SoilAnalysisScreen());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text("drone_request".tr),
                ),
              ],
            ),
          ),
          Positioned(
            top: -15,
            right: 20,
            child: Image.asset(
              "assets/images/drone.png",
              width: 140,
              fit: BoxFit.contain,
            ), // Add drone image
          ),
        ],
      ),
    );
  }

  // 4. Articles Section
  Widget _buildArticlesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "articles".tr,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF005F59),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _buildArticleCard(
                "winter".tr,
                "article_1".tr,
                Colors.blue,
                Icons.ac_unit,
                "https://www.pesticidereform.org/pesticides-human-health/",
              ),
            ),
            const SizedBox(width: 8), // Add spacing between cards
            Expanded(
              child: _buildArticleCard(
                "spring".tr,
                "article_2".tr,
                Colors.green,
                Icons.local_florist,
                "https://www.springsoflifeirrigation.com/blog/how-is-over-irrigation-damaging-to-soil",
              ),
            ),
            const SizedBox(width: 8), // Add spacing between cards
            Expanded(
              child: _buildArticleCard(
                "summer".tr,
                "article_3".tr,
                Colors.orange,
                Icons.wb_sunny,
                "https://www.epa.gov/climateimpacts/climate-change-impacts-agriculture-and-food-supply",
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildArticleCard(
      String season,
      String title,
      Color color,
      IconData icon,
      String url,
      ) {
    return GestureDetector(
      onTap: () async {
        final uri = Uri.parse(url);
        try {
          if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
            throw 'Could not launch $url';
          }
        } catch (e) {
          // Optional: show error to user
          debugPrint('Error launching URL: $e');
          Get.snackbar(
            "Error",
            "Failed to open article details",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      },
      child: Container(
        width: double.infinity,
        height: 100,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    season,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  Icon(
                    icon,
                    color: Colors.white,
                    size: 14,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }


  //5.More info about nab tar app
  Widget _buildMoreInfoCard() {
    return Container(
      width: double.infinity,
      height: 100, // Adjusted height for text & image
      decoration: BoxDecoration(
        color: Colors.indigo,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Image.asset(
            "assets/images/img.png",
            height: 100, // Matches parent height
            width: 100, // Adjust width as needed
            fit: BoxFit.cover, // Cover the available space
          ),

          // Expanded Text
          Expanded(
            child: Text(
              "more_know".tr,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2, // Prevents overflow
              overflow: TextOverflow.ellipsis, // Add '...' for long text
            ),
          ),
        ],
      ),
    );
  }

  void _showStormAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          contentPadding: EdgeInsets.all(20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 50, color: Colors.red),
              SizedBox(height: 10),
              Text(
                "Warning",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                "Storm Coming",
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Hide", style: TextStyle(color: Colors.red)),
                    style: TextButton.styleFrom(
                      side: BorderSide(color: Colors.red),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      langController.changeScreenIndex(
                        2,
                      ); // Navigate to weather screen
                    },
                    child: Text("Weather"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
