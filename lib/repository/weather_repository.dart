import 'dart:developer';

import '../api/dio_service.dart';
import '../model/weather_data.dart';

class WeatherRepository {
  final DioService dioService; // Instance of the ApiService class to perform API requests.

  WeatherRepository({required this.dioService});

  Future<WeatherData> getWeather() async {
    try {
      final response = await dioService.getWeather();
      final weatherObj = WeatherData.fromJson(response.data);
      return weatherObj;
    } catch (e) {
      throw Exception('(Repository): Failed to get weather');
    }
  }
}