import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

extension IntExtension on int {
  String getWeatherDesc() {
    if (this == 0) {
      return 'Clear';
    }
    else if (this >= 1 && this <= 3) {
      return 'Partly-Cloud';
    }
    else if (this == 45) {
      return 'Fog';
    }
    else if (this == 48) {
      return 'Wind';
    }
    else if (this >= 51 && this <= 55) {
      return 'Drizzle';
    }
    else if (this >= 56 && this <= 57) {
      return 'Freezing Drizzle';
    }
    else if (this >= 61 && this <= 65) {
      return 'Rain';
    }
    else if (this >= 66 && this <= 67) {
      return 'Freezing Rain';
    }
    else if (this >= 71 && this <= 77) {
      return 'Snow Fall';
    }
    else if (this >= 80 && this <= 82) {
      return 'Rain Showers';
    }
    else if (this >= 85 && this <= 86) {
      return 'Snow Showers';
    }
    else if (this == 95) {
      return 'Thunderstorm';
    }
    else if (this >= 96 && this <= 99) {
      return 'Heavy Thunderstorm';
    }
    return 'unknown';
  }

  String getWeatherSvg({required bool isDay}) {
    if (this == 0) {
      return isDay ? 'assets/svg/sun.svg' : 'assets/svg/moon.svg';
    }
    else if (this >= 1 && this <= 3) {
      return isDay ? 'assets/svg/cloud-sun.svg' : 'assets/svg/cloud-moon.svg';
    }
    else if (this == 45) {
      return 'assets/svg/fog.svg';
    }
    else if (this == 48) {
      return 'assets/svg/wind.svg';
    }
    else if (this >= 51 && this <= 55) {
      return 'assets/svg/drizzle.svg';
    }
    else if (this >= 56 && this <= 57) {
      return 'assets/svg/freezing-drizzle.svg';
    }
    else if (this >= 61 && this <= 65) {
      return isDay ? 'assets/svg/rain-sun.svg' : 'assets/svg/rain-moon.svg';
    }
    else if (this >= 66 && this <= 67) {
      return isDay ? 'assets/svg/freeing-rain-sun.svg' : 'assets/svg/freezing-rain-moon.svg';
    }
    else if (this >= 71 && this <= 77) {
      return 'assets/svg/snowfall.svg';
    }
    else if (this >= 80 && this <= 82) {
      return 'assets/svg/rain-showers.svg';
    }
    else if (this >= 85 && this <= 86) {
      return 'assets/svg/snow-showers.svg';
    }
    else if (this == 95) {
      return 'assets/svg/thunderstorm.svg';
    }
    else if (this >= 96 && this <= 99) {
      return 'assets/svg/thunderstorm-heavy.svg';
    }
    return 'unknown';
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

  SvgPicture loadAssetSvg({
    double? height,
    double? width,
  }) {
    return SvgPicture.asset(
      this,
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

  /// used in hourly widget to show icon according for sunrise nd sunset
  bool checkIsDay() {
    final currTime = this;

    final sunrise = DateTime(
        year, month, day, 6, 00);
    final sunset = DateTime(
        year, month, day, 15, 00);

    if (currTime.isAfter(sunrise) && currTime.isBefore(sunset)) {
      return true;
    }
    return false;
  }
}

extension FormattedTemp on double {
  static RegExp regex = RegExp(r'([.]*0)(?!.*\d)');

  String formatTempInC() {
    return "${toString().replaceAll(regex, '')}\u00B0C";
  }
}

extension FormatDateTime on DateTime {
  String formatTime24H() {
    return DateFormat.Hm().format(this);
  }

  String formatDate() {
    return DateFormat('d, MMM').format(this);
  }
}