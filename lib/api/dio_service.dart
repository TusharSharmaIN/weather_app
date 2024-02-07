import 'package:dio/dio.dart';

import 'dio_client.dart';

class DioService {
  static DioService? _instance;

  factory DioService() => _instance ??= DioService._();

  DioService._();

  static const latitude = 52.52;
  static const longitude = 13.41;

  Future<Response> getWeather() async {
    Map<String, dynamic> queryParameters = {
      "latitude": latitude,
      "longitude": longitude,
      "current[]": [
        "temperature_2m",
        "weathercode",
      ],
      "daily[]": [
        "weathercode",
        "temperature_2m_max",
        "temperature_2m_min",
      ],
      "timezone": "auto",
      "past_days": "3",
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
