import 'package:json_annotation/json_annotation.dart';

part 'current.g.dart';

@JsonSerializable()
class Current {
  @JsonKey(name: 'temperature_2m')
  final double temperature2M;

  @JsonKey(name: 'weathercode')
  final int weatherCode;

  Current({
    required this.temperature2M,
    required this.weatherCode,
  });

  factory Current.fromJson(Map<String, dynamic> json) => _$CurrentFromJson(json);

  Map<String, dynamic> toJson() => _$CurrentToJson(this);
}