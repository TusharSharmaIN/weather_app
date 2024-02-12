import '../services/weather_api_service.dart';
import '../models/weather_data.dart';

class WeatherRepository {
  final WeatherApiService weatherApiService = WeatherApiService();

  WeatherRepository();

  Future<WeatherData> getWeather({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final response = await weatherApiService.getWeather(
        latitude: latitude,
        longitude: longitude,
      );
      final weatherObj = WeatherData.fromJson(response.data);
      return weatherObj;
    } catch (e) {
      throw Exception('(Repository): Failed to get weather');
    }
  }
}
