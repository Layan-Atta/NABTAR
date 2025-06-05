// Controller for Managing Tab Changes
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/report_model.dart';

class ReportController extends GetxController {
  var isLoading = false.obs;
  // List of reports
  RxList<ReportModel> reportList = <ReportModel>[].obs;

  /// Save a report to Firestore
  Future<bool> saveReport(ReportModel report) async {
    try {
      isLoading.value = true;
      await FirebaseFirestore.instance
          .collection('reports')
          .add(report.toFirestore());
      Get.snackbar(
        "Success",
        "Report saved successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      return true;
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to save report",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print("Error saving report: $e");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Load reports for a user
  Future<void> loadReports(String userId) async {
    try {
      isLoading.value = true;
      final snapshot =
          await FirebaseFirestore.instance
              .collection('reports')
              .where('userId', isEqualTo: userId)
              .get();

      reportList.value =
          snapshot.docs.map((doc) => ReportModel.fromFirestore(doc)).toList();
    } catch (e) {
      print("Error loading reports: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
