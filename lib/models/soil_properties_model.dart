class SoilProperties {
  final int nitrogen; // N Nitrogen Level
  final int phosphorus; // P Phosphorus Level
  final int potassium; // K Potassium Level
  final double ph; //PH of soil
  final String soil; //soil type

  SoilProperties({
    required this.nitrogen,
    required this.phosphorus,
    required this.potassium,
    required this.ph,
    required this.soil,
  });

  // Factory method to create a SoilProperties object from JSON
  factory SoilProperties.fromJson(Map<String, dynamic> json) {
    return SoilProperties(
      nitrogen: json['N'],
      phosphorus: json['P'],
      potassium: json['K'],
      ph: (json['ph'] as num).toDouble(),
      soil: json['soil'] ?? "No soil", // Handle missing data
    );
  }

  // Convert SoilProperties object to JSON
  Map<String, dynamic> toJson() {
    return {"N": nitrogen, "P": phosphorus, "K": potassium, "ph": ph, "soil": soil};
  }
}
