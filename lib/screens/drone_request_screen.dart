import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nabtar_app/controllers/language_controller.dart';
import 'package:nabtar_app/controllers/user_controller.dart';

import '../controllers/drone_controller.dart';

class DroneRequestScreen extends StatelessWidget {
  final DroneController controller = Get.put(DroneController());
  final UserController userController = Get.find();
  final LanguageController langController = Get.find();

  DroneRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    controller.stepIndex.value = 0;
    return
      SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //screen title and back icon
                IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_rounded,
                    color: Color(0xFF116567),
                    size: 28,
                  ),
                  onPressed: () {
                    langController.changeScreenIndex(1);
                  },
                ),
                Text(
                  "drone_request".tr,
                  style: TextStyle(
                    color: Color(0xFF116567),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Icon(
                  Icons.more_vert,
                  color: Color(0xFF116567),
                  size: 28,
                ),
              ],
            ),
            SizedBox(height: 10),
            _buildStepIndicator(),
            SizedBox(height: 20),

            SizedBox(height: 10),
             Obx(() {
                if (controller.stepIndex.value == 1) {
                  return _buildCalendar();
                } else if (controller.stepIndex.value == 2) {
                  return _buildSummaryInfo();
                } else {
                  return SizedBox.shrink();
                }
              }),


            SizedBox(height: 20),

            Center(
              child: ElevatedButton(
                onPressed: controller.nextStep,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF3282B8),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "confirm".tr,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Obx(
      () => Column(
        children: [
          _buildStep("farm_location".tr, 0),
          _buildStep("date_determining".tr, 1),
          _buildStep("request_summary".tr, 2),
        ],
      ),
    );
  }

  Widget _buildStep(String title, int step) {
    return Row(
      children: [
        Column(
          children: [
            Container(
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                color:
                    controller.stepIndex.value >= step
                        ? Colors.blue
                        : Colors.grey,
                shape: BoxShape.circle,
              ),
            ),
            if (step != 2)
              Container(
                width: 2,
                height: 30,
                color:
                    controller.stepIndex.value > step
                        ? Colors.blue
                        : Colors.grey,
              ),
          ],
        ),
        SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(
            color:
                controller.stepIndex.value >= step ? Colors.black : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildCalendar() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            "choose_date".tr,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10,),
          Obx(
            () => Text(
              "${DateFormat.yMMMM().format(controller.selectedDate.value)}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
            ),
            itemCount: 31,
            itemBuilder: (context, index) {
              return Obx(
                () => GestureDetector(
                  onTap: () {
                    controller.updateDate(
                      DateTime(
                        controller.selectedDate.value.year,
                        controller.selectedDate.value.month,
                        index + 1,
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color:
                          controller.selectedDate.value.day == (index + 1)
                              ? Colors.blue
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "${index + 1}",
                      style: TextStyle(
                        color:
                            controller.selectedDate.value.day == (index + 1)
                                ? Colors.white
                                : Colors.black,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryInfo() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "request_summary".tr,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.place, color: Colors.blue),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  userController.user.value.location.isNotEmpty
                      ? userController.user.value.location
                      : "no_location_selected".tr,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.calendar_today, color: Colors.blue),
              SizedBox(width: 8),
              Text(
                DateFormat.yMMMMd().format(controller.selectedDate.value),
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.history_toggle_off, color: Colors.blue),
              SizedBox(width: 8),
              Text(
                'Status: a waiting conformation',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
