import 'package:json_annotation/json_annotation.dart';

import 'current.dart';
import 'current_units.dart';
import 'daily.dart';
import 'daily_units.dart';

part 'weather_data.g.dart';

@JsonSerializable(explicitToJson: true)
class WeatherData {
  @JsonKey(name: 'latitude')
  final double latitude;

  @JsonKey(name: 'longitude')
  final double longitude;

  @JsonKey(name: 'timezone')
  final String timezone;

  @JsonKey(name: 'current')
  final Current current;

  @JsonKey(name: 'current_units')
  final CurrentUnits currentUnits;

  @JsonKey(name: 'daily')
  final Daily daily;

  @JsonKey(name: 'daily_units')
  final DailyUnits dailyUnits;

  WeatherData({
    required this.latitude,
    required this.longitude,
    required this.timezone,
    required this.current,
    required this.currentUnits,
    required this.daily,
    required this.dailyUnits,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) => _$WeatherDataFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherDataToJson(this);
}