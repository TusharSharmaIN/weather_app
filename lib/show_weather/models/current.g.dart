// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Current _$CurrentFromJson(Map<String, dynamic> json) => Current(
      temperature2M: (json['temperature_2m'] as num).toDouble(),
      weatherCode: json['weathercode'] as int,
      isDay: json['is_day'] as int,
    );

Map<String, dynamic> _$CurrentToJson(Current instance) => <String, dynamic>{
      'temperature_2m': instance.temperature2M,
      'weathercode': instance.weatherCode,
      'is_day': instance.isDay,
    };
