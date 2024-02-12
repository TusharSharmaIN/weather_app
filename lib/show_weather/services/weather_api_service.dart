import 'package:dio/dio.dart';

import '../../api/dio_client.dart';

class WeatherApiService {
  static WeatherApiService? _instance;

  factory WeatherApiService() => _instance ??= WeatherApiService._();

  WeatherApiService._();

  //  for testing, local coordinates
  static const lat = 26.4498919;
  static const long = 80.3513054;

  Future<Response> getWeather({
    required double latitude,
    required double longitude,
  }) async {
    Map<String, dynamic> queryParameters = {
      "latitude": latitude,
      "longitude": longitude,
      "current[]": [
        "temperature_2m",
        "weathercode",
        "is_day",
      ],
      "daily[]": [
        "weathercode",
        "temperature_2m_max",
        "temperature_2m_min",
      ],
      "hourly[]": ["temperature_2m", "weather_code"],
      "timezone": "auto",
      "forecast_days": "7",
    };

    var response = await DioClient().dio.get(
          'forecast',
          queryParameters: queryParameters,
        );

    if (response.statusCode == 200) {
      return response;
    } else {
      throw "Unable to retrieve posts.";
    }
  }
}
