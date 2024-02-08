import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

extension IntExtension on int {
  String getWeatherDesc() {
    if (this == 0) {
      return 'Sunny';
      return 'assets/images/sun.png';
    }
    else if (this >= 1 && this <= 3) {
      return 'Partly-Cloudy';
      return 'assets/images/partly-cloud.png';
    }
    else if (this >= 45 && this <= 48) {
      return 'Cloudy';
      return 'assets/images/cloud.png';
    }
    else if (this >= 51 && this <= 55) {
      return 'Windy';
      return 'assets/images/wind.png';
    }
    else if (this >= 61 && this <= 67) {
      return 'Light-Rain';
      return 'assets/images/light-rain.png';
    }
    else if (this >= 71 && this <= 77) {
      return 'Light-Snow';
      return 'assets/images/light-snow.png';
    }
    else if (this >= 80 && this <= 82) {
      return 'Rainy';
      return 'assets/images/rain.png';
    }
    else if (this >= 85 && this <= 86) {
      return 'Snow';
      return 'assets/images/snow.png';
    }
    else if (this >= 95) {
      return 'Thunderstorm';
      return 'assets/images/thunderstorm.png';
    }
    return 'assets/images/cloud-unknown.png';
  }

  String getWeatherImage() {
    if (this == 0) {
      return 'assets/images/sun.png';
    }
    else if (this >= 1 && this <= 3) {
      return 'assets/images/partly-cloud.png';
    }
    else if (this >= 45 && this <= 48) {
      return 'assets/images/cloud.png';
    }
    else if (this >= 51 && this <= 55) {
      return 'assets/images/wind.png';
    }
    else if (this >= 61 && this <= 67) {
      return 'assets/images/light-rain.png';
    }
    else if (this >= 71 && this <= 77) {
      return 'assets/images/light-snow.png';
    }
    else if (this >= 80 && this <= 82) {
      return 'assets/images/rain.png';
    }
    else if (this >= 85 && this <= 86) {
      return 'assets/images/snow.png';
    }
    else if (this >= 95) {
      return 'assets/images/thunderstorm.png';
    }
    return 'assets/images/cloud-unknown.png';
  }

  IconData getWeatherIcon() {
    if (this == 0) {
      return FontAwesomeIcons.sun;
    }
    else if (this >= 1 && this <= 3) {
      return FontAwesomeIcons.cloudSun;
    }
    else if (this >= 45 && this <= 48) {
      return FontAwesomeIcons.cloud;
    }
    else if (this >= 51 && this <= 55) {
      return FontAwesomeIcons.wind;
    }
    else if (this >= 61 && this <= 67) {
      return FontAwesomeIcons.cloudRain;
    }
    else if (this >= 71 && this <= 77) {
      return FontAwesomeIcons.snowflake;
    }
    else if (this >= 80 && this <= 82) {
      return FontAwesomeIcons.cloudShowersHeavy;
    }
    else if (this >= 85 && this <= 86) {
      return FontAwesomeIcons.solidSnowflake;
    }
    else if (this >= 95) {
      return FontAwesomeIcons.cloudBolt;
    }
    return FontAwesomeIcons.faceSadCry;
  }
}

extension StringExtension on String {
  Image loadAssetImage({
    double? height,
    double? width,
  }) {
    return Image(
    image: AssetImage(this),
    height: height ?? 200,
    width: width ?? 200,
    );
  }
}

extension DayExtension on DateTime {
  String getDayName() {
    if (weekday == DateTime.now().weekday) {
      return 'Today';
    } else {
      switch (weekday) {
        case 1:
          return 'Mon';
        case 2:
          return 'Tue';
        case 3:
          return 'Wed';
        case 4:
          return 'Thu';
        case 5:
          return 'Fri';
        case 6:
          return 'Sat';
        case 7:
          return 'Sun';
        default:
          return '';
      }
    }
  }
}