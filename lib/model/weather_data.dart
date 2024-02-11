import 'package:json_annotation/json_annotation.dart';

import 'current.dart';
import 'daily.dart';
import 'hourly.dart';

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

  @JsonKey(name: 'daily')
  final Daily daily;

  @JsonKey(name: 'hourly')
  final Hourly hourly;

  WeatherData({
    required this.latitude,
    required this.longitude,
    required this.timezone,
    required this.current,
    required this.daily,
    required this.hourly,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) => _$WeatherDataFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherDataToJson(this);
}