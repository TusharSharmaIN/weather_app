import 'package:json_annotation/json_annotation.dart';

part 'daily.g.dart';

@JsonSerializable()
class Daily {
  @JsonKey(name: 'weathercode')
  final List<int> weatherCode;

  @JsonKey(name: 'temperature_2m_max')
  final List<double> temperature2MMax;

  @JsonKey(name: 'temperature_2m_min')
  final List<double> temperature2MMin;

  @JsonKey(name: "time")
  List<DateTime> time;

  Daily({
    required this.weatherCode,
    required this.temperature2MMax,
    required this.temperature2MMin,
    required this.time,
  });

  factory Daily.fromJson(Map<String, dynamic> json) => _$DailyFromJson(json);

  Map<String, dynamic> toJson() => _$DailyToJson(this);
}