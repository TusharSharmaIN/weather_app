import 'package:flutter/material.dart';

extension IntExtension on int {
  String getWeatherDesc() {
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
