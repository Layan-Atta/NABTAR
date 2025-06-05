import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nabtar_app/controllers/user_controller.dart';

class SettingScreen extends StatelessWidget {
  SettingScreen({super.key});
  final UserController userData = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header Section with Profile
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color(0xFF116567),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.settings, size: 50, color: Colors.white),
                  SizedBox(width: 10),
                  Text(
                    "profile".tr,
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),

              Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: Colors.black, size: 30),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      userData.user.value.fullName,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10),
              _buildProfileItem(Icons.email, userData.user.value.email),
              _buildProfileItem(Icons.phone, userData.user.value.phone),
              _buildProfileItem(Icons.location_on, userData.user.value.location),
            ],
          ),
        ),

        // Settings List
        Expanded(
          child: ListView(
            padding: EdgeInsets.all(20),
            children: [
              SizedBox(height: 10),
              ListTile(
                title: Text("logout".tr),
                trailing: Icon(Icons.logout),
                onTap: () async {
                 await userData.logout();
                  // Logout logic here
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Reusable Widget for Profile Info
  Widget _buildProfileItem(IconData icon, String value) {
    if (value == null || value.isEmpty) return SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 6.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 18),
          SizedBox(width: 8),
          Flexible(
            child: Text(
              value,
              style: TextStyle(color: Colors.white70, fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
