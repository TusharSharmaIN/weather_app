// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Daily _$DailyFromJson(Map<String, dynamic> json) => Daily(
      weatherCode:
          (json['weathercode'] as List<dynamic>).map((e) => e as int).toList(),
      temperature2MMax: (json['temperature_2m_max'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      temperature2MMin: (json['temperature_2m_min'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      time: (json['time'] as List<dynamic>)
          .map((e) => DateTime.parse(e as String))
          .toList(),
    );

Map<String, dynamic> _$DailyToJson(Daily instance) => <String, dynamic>{
      'weathercode': instance.weatherCode,
      'temperature_2m_max': instance.temperature2MMax,
      'temperature_2m_min': instance.temperature2MMin,
      'time': instance.time.map((e) => e.toIso8601String()).toList(),
    };
