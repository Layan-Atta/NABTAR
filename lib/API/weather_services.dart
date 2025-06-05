import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherService {
  //Default: 862e0d47428c236fd9a6cc5e34a39b9d
  //my-MyApp-Weather: 12c6ea3cc9f075b0377d938b9468f6f5
  final String apiKey = '12c6ea3cc9f075b0377d938b9468f6f5';

  //url API to get history weather in past year
  final String baseUrl = "https://archive-api.open-meteo.com/v1/archive";

  Future<Map<String, dynamic>> getWeatherByCity(
    String cityName, {
    String startDate = '2024-03-01', //from spring to end summer
    String endDate = '2024-08-31',
  }) async {
    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('weather data:$data');

      // Extracting the location data (latitude and longitude)
      double lat = data['coord']['lat'];
      double lon = data['coord']['lon'];
      // Check if rain data exists and get the 1h rainfall, else default to 0.0
      double rainfall = data['rain'] != null ? data['rain']['1h'] ?? 0.0 : 0.0;
      // Get the weather description from the API response (description like(sunny,clear sky ,))
      String weatherDescription = data['weather'][0]['description'];
      // print('weather description:$weatherDescription');

      var dataHistory = await getHistoricalWeather(
        lat,
        lon,
        startDate,
        endDate,
      );
      // print('history weather data:$dataHistory');

      return {
        'temperature': data['main']['temp'],
        'humidity': data['main']['humidity'],
        'rainfall': rainfall,
        'description': weatherDescription,
        'location': cityName,
        'rainfallPerSeason': dataHistory['avg_rainfall_seasons'],
        'averageTemperature': dataHistory['average_temperature'],
        'averageHumidity': dataHistory['average_humidity'],
        'totalRainfall': dataHistory['total_rainfall'],
      };
    } else {
      throw Exception('Failed to fetch weather data');
    }
  }

  Future<Map<String, dynamic>> getHistoricalWeather(
    double lat,
    double lon,
    String startDate,
    String endDate,
  ) async {
    final url = Uri.parse(
      "$baseUrl?latitude=$lat&longitude=$lon&start_date=$startDate&end_date=$endDate&daily=temperature_2m_max,temperature_2m_min,relative_humidity_2m_mean,precipitation_sum&timezone=auto",
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return calculateWeatherStats(data);
    } else {
      return {
        "error": "Failed to fetch data",
        "status_code": response.statusCode,
      };
    }
  }

  Map<String, dynamic> calculateWeatherStats(Map<String, dynamic> data) {
    try {
      if (!data.containsKey("daily")) {
        return {"error": "Missing 'daily' data in API response"};
      }

      Map<String, dynamic> dailyData = data["daily"];

      List<double> temperatures =
          (dailyData["temperature_2m_max"] as List)
              .map((val) => (val as num).toDouble())
              .toList();

      List<double> humidityValues =
          (dailyData["relative_humidity_2m_mean"] as List)
              .map((val) => (val as num).toDouble())
              .toList();

      List<double> rainfallValues =
          (dailyData["precipitation_sum"] as List)
              .map((val) => (val as num).toDouble())
              .toList();

      if (temperatures.isEmpty ||
          humidityValues.isEmpty ||
          rainfallValues.isEmpty) {
        return {"error": "No valid data available for the given period"};
      }

      double avgTemp =
          temperatures.reduce((a, b) => a + b) / temperatures.length;
      double avgHumidity =
          humidityValues.reduce((a, b) => a + b) / humidityValues.length;
      double totalRainfall = rainfallValues.reduce((a, b) => a + b);

      // Average rainfall per season (4 seasons)
      double avgRainfallSeasons = totalRainfall / 2;

      return {
        "average_temperature": avgTemp,
        "average_humidity": avgHumidity,
        "total_rainfall": totalRainfall,
        "avg_rainfall_seasons": avgRainfallSeasons,
      };
    } catch (e) {
      return {"error": "Invalid data format: $e"};
    }
  }

  //from winter strat to end with fall
  /*
    seasons = {
        "winter": ("2023-12-01", "2024-02-28"),
        "spring": ("2024-03-01", "2024-05-31"),
        "summer": ("2024-06-01", "2024-08-31"),
        "fall": ("2024-09-01", "2024-11-30")
    }
       */
}
