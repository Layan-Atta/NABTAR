class CropPrediction {
  final String recommendedCrop;
  final Map<String, double> probabilities;

  CropPrediction({required this.recommendedCrop, required this.probabilities});

  // Factory constructor to create an instance from JSON
  factory CropPrediction.fromJson(Map<String, dynamic> json) {
    return CropPrediction(
      recommendedCrop: json['recommended_crop'],
      probabilities: Map<String, double>.from(json['probabilities']),
    );
  }
}
