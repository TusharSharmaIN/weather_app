import 'package:flutter/material.dart';

import '../model/weather_data.dart';
import '../repository/weather_repository.dart';

class HomeViewModel extends ChangeNotifier {
  final WeatherRepository weatherRepository;

  HomeViewModel({required this.weatherRepository});

  WeatherData? _weatherData;
  bool _loading = false;
  String _errorMessage = '';
  //
  get weatherData => _weatherData;
  bool get isLoading => _loading;
  String get errorMessage => _errorMessage;

  Future<void> fetchWeatherData() async {
    _loading = true;
    notifyListeners();
    _errorMessage = '';

    try {
      _weatherData = await weatherRepository.getWeather();
      print(_weatherData?.toJson().toString());
    } catch (e) {
      _errorMessage = '(ViewModel): Failed to fetch weather';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}