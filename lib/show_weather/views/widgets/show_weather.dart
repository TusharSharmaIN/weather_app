import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/extensions.dart';
import 'weather_for_today.dart';
import 'weather_for_week.dart';

class ShowWeather extends StatefulWidget {
  const ShowWeather({
    super.key,
    required this.subLocality,
    required this.locality,
    required this.currTemp,
    required this.weatherCode,
    required this.maxTemp,
    required this.minTemp,
    required this.isDay,
    required this.hourlyTimes,
    required this.hourlyWeatherCodes,
    required this.hourlyTemperatures,
    required this.weekDates,
    required this.weekWeatherCodes,
    required this.weekMinTemps,
    required this.weekMaxTemps,
  });

  final String subLocality;
  final String locality;
  final double currTemp;
  final int weatherCode;
  final double maxTemp;
  final double minTemp;
  final bool isDay;
  final List<String> hourlyTimes;
  final List<int> hourlyWeatherCodes;
  final List<double> hourlyTemperatures;
  final List<DateTime> weekDates;
  final List<int> weekWeatherCodes;
  final List<double> weekMinTemps;
  final List<double> weekMaxTemps;

  @override
  State<ShowWeather> createState() => _ShowWeatherState();
}

class _ShowWeatherState extends State<ShowWeather> {
  late String cityName;
  int nDaysForecast = 7;

  @override
  void initState() {
    super.initState();
    cityName = "${widget.subLocality}, ${widget.locality}";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ///  location tag
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              const Icon(Icons.location_on, size: 24.0, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                cityName,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        /// SVG Icon
        SvgPicture.asset(
          widget.weatherCode.getWeatherSvg(isDay: widget.isDay),
          height: 160,
        ),
        const SizedBox(height: 16),

        /// Temperature
        Text(
          widget.currTemp.formatTempInC(),
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 36,
          ),
        ),
        const SizedBox(height: 8),

        /// weather description
        Text(
          widget.weatherCode.getWeatherDesc(),
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),

        /// min and max
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Min: ${widget.minTemp.formatTempInC()}',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 32),
            Text(
              'Max: ${widget.maxTemp.formatTempInC()}',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        /// Today hour-wise weather
        WeatherForToday(
          times: widget.hourlyTimes,
          weatherCodes: widget.hourlyWeatherCodes,
          temperatures: widget.hourlyTemperatures,
        ),
        const SizedBox(height: 16),

        /// Next 7 day forecast
        WeatherForWeek(
          nDaysForecast: nDaysForecast,
          dates: widget.weekDates,
          weatherCodes: widget.weekWeatherCodes,
          minTemps: widget.weekMinTemps,
          maxTemps: widget.weekMaxTemps,
        ),
      ],
    );
  }
}
