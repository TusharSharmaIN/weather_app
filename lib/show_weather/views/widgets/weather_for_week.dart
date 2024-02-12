import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constants/app_colors.dart';
import '../../../utils/extensions.dart';

class WeatherForWeek extends StatelessWidget {
  const WeatherForWeek({
    super.key,
    required this.nDaysForecast,
    required this.dates,
    required this.weatherCodes,
    required this.minTemps,
    required this.maxTemps,
  });

  final int nDaysForecast;
  final List<DateTime> dates;
  final List<int> weatherCodes;
  final List<double> minTemps;
  final List<double> maxTemps;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
      ),
      child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(14)),
            color: AppColors.darkCerulean.withOpacity(0.30),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "$nDaysForecast Day Forecast",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Icon(
                        Icons.calendar_month_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 16,
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: dates.length,
                    itemBuilder: (BuildContext context, int index) {
                      return DailyWeather(
                        // date: data.daily.time[index].getDayName(),
                        date: dates[index].getDayName(),
                        minTemp: minTemps[index],
                        maxTemp: maxTemps[index],
                        weatherCode: weatherCodes[index],
                      );
                    },
                  ),
                ),
              ],
            ),
          )),
    );
  }
}

class DailyWeather extends StatelessWidget {
  const DailyWeather({
    super.key,
    required this.date,
    required this.minTemp,
    required this.maxTemp,
    required this.weatherCode,
  });

  final String date;
  final double minTemp;
  final double maxTemp;
  final int weatherCode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 60,
            child: Text(
              date,
              style: GoogleFonts.questrial(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
          weatherCode.getWeatherSvg(isDay: true).loadAssetSvg(
            height: 28,
            width: 28,
          ),
          Row(
            children: [
              Text(
                minTemp.formatTempInC(),
                style: GoogleFonts.poppins(
                  color: Colors.white.withOpacity(0.50),
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                maxTemp.formatTempInC(),
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
