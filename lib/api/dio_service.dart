import 'package:dio/dio.dart';

import 'dio_client.dart';

class DioService {
  static DioService? _instance;

  factory DioService() => _instance ??= DioService._();

  DioService._();

  static const lat = 26.4498919;
  static const long = 80.3513054;

  Future<Response> getWeather({
    required double latitude,
    required double longitude,
  }) async {
    Map<String, dynamic> queryParameters = {
      "latitude": lat,
      "longitude": long,
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
      "timezone": "auto",
      "forecast_days": "3",
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
