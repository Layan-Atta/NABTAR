class Weather {
  final double temperature; //temperature in celsius for current location
  final double humidity; //humidity for current location
  final double rainfall; //current rainfall in mm
  final String description; // e.g., "clear sky", "light rain"
  final String location;
  final double
  rainfallPerSeason; //rainfall per season in mm for current location (4 seasons)
  final double
  averageTemperature; //average temperature in celsius for the all season
  final double averageHumidity; //average humidity for the all season
  final double totalRainfall; //total rainfall in mm for the all season

  Weather({
    required this.temperature,
    required this.humidity,
    required this.rainfall,
    required this.description,
    required this.location,
    required this.rainfallPerSeason,
    required this.averageTemperature,
    required this.averageHumidity,
    required this.totalRainfall,
  });

  // Factory method to create a Weather object from JSON
  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      temperature: (json['temperature'] as num).toDouble(),
      humidity: (json['humidity'] as num).toDouble(),
      rainfall: (json['rainfall'] as num).toDouble(),
      description:
          json['description'] ?? "No description", // Handle missing data
      location: json['location'] ?? "No location", // Handle missing data
      rainfallPerSeason: (json['rainfallPerSeason'] as num).toDouble(),
      averageTemperature: (json['averageTemperature'] as num).toDouble(),
      averageHumidity: (json['averageHumidity'] as num).toDouble(),
      totalRainfall: (json['totalRainfall'] as num).toDouble(),
    );
  }

  // Convert Weather object to JSON
  Map<String, dynamic> toJson() {
    return {
      "temperature": temperature,
      "humidity": humidity,
      "rainfall": rainfall,
      "description": description,
      "location": location,
      "rainfallPerSeason": rainfallPerSeason,
      "averageTemperature": averageTemperature,
      "averageHumidity": averageHumidity,
      "totalRainfall": totalRainfall,
    };
  }
}
