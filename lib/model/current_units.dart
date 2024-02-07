import 'package:json_annotation/json_annotation.dart';

part 'current_units.g.dart';

@JsonSerializable()
class CurrentUnits {
  @JsonKey(name: 'temperature_2m')
  final String temperature2M;

  CurrentUnits({
    required this.temperature2M,
  });

  factory CurrentUnits.fromJson(Map<String, dynamic> json) => _$CurrentUnitsFromJson(json);

  Map<String, dynamic> toJson() => _$CurrentUnitsToJson(this);
}