import 'package:json_annotation/json_annotation.dart';

part 'hourly.g.dart';

@JsonSerializable()
class Hourly {
  @JsonKey(name: "time")
  final List<String> time;

  @JsonKey(name: "temperature_2m")
  final List<double> temperature2M;

  @JsonKey(name: "weather_code")
  final List<int> weatherCode;

  Hourly({
    required this.time,
    required this.temperature2M,
    required this.weatherCode,
  });

  factory Hourly.fromJson(Map<String, dynamic> json) => _$HourlyFromJson(json);

  Map<String, dynamic> toJson() => _$HourlyToJson(this);
}