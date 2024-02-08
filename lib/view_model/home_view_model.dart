import 'package:flutter/material.dart';

import '../location/location_service.dart';
import '../model/weather_data.dart';
import '../repository/weather_repository.dart';

class HomeViewModel extends ChangeNotifier {
  final WeatherRepository weatherRepository;

  HomeViewModel({required this.weatherRepository});

  WeatherData? _weatherData;
  bool _loading = false;
  String _errorMessage = '';
  final LocationService _locationService = LocationService();
  late LocationData _locationData;

  /// getters
  get weatherData => _weatherData;

  bool get isLoading => _loading;

  String get errorMessage => _errorMessage;

  LocationService get locationService => _locationService;

  double get latitude => _locationData.latitude;

  double get longitude => _locationData.longitude;

  String get subLocality => _locationData.subLocality;

  String get locality => _locationData.locality;

  Future<void> initData({required String args}) async {
    await getPosition();
    await fetchWeatherData();
  }

  Future<void> fetchWeatherData() async {
    _loading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      _weatherData = await weatherRepository.getWeather(
        latitude: latitude,
        longitude: longitude,
      );
    } catch (e) {
      _errorMessage = '(ViewModel): Failed to fetch weather';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> getPosition() async {
    _locationData = await _locationService.getCoordinates();
  }
}
