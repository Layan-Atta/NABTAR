import 'package:cloud_firestore/cloud_firestore.dart';

class ReportModel {
  final String userId;
  final String location;
  final double rainfall;
  final double humidity;
  final double temperature;
  final List<String> recommendedCrops;
  final String scanDate;

  ReportModel({
    required this.userId,
    required this.location,
    required this.rainfall,
    required this.humidity,
    required this.temperature,
    required this.recommendedCrops,
    required this.scanDate,
  });

  // Convert to Firestore format
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'location': location,
      'rainfall': rainfall,
      'humidity': humidity,
      'temperature': temperature,
      'recommendedCrops': recommendedCrops,
      'scanDate': scanDate,
    };
  }

  // Convert from Firestore document
  factory ReportModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ReportModel(
      userId: data['userId'] ?? '',
      location: data['location'] ?? '',
      rainfall: (data['rainfall'] ?? 0).toDouble(),
      humidity: (data['humidity'] ?? 0).toDouble(),
      temperature: (data['temperature'] ?? 0).toDouble(),
      recommendedCrops: List<String>.from(data['recommendedCrops'] ?? []),
      scanDate: data['scanDate'],
    );

  }
}
