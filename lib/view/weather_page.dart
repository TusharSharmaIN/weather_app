import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import '../model/weather_data.dart';
import '../utils/extensions.dart';
import '../view_model/home_view_model.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  late final WeatherData weatherObj;
  late final HomeViewModel homeViewModel;

  @override
  void initState() {
    super.initState();
    homeViewModel = context.read<HomeViewModel>();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await homeViewModel.initData(args: "init");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Selector<HomeViewModel, Tuple2<bool, String>>(
                      selector: (_, viewModel) => Tuple2(
                        viewModel.isLoading,
                        viewModel.errorMessage,
                      ),
                      builder: (context, data, child) {
                        WeatherData? weatherData = homeViewModel.weatherData;
                        return data.item1
                            ? const Center(
                                //  progress indicator
                                child: CircularProgressIndicator(),
                              )
                            : data.item2.isNotEmpty
                                ? Center(
                                    //  error widget
                                    child: Text(data.item2),
                                  )
                                : weatherData != null
                                    ? ShowWeather(
                                        weatherData: weatherData,
                                        locality: homeViewModel.locality,
                                      )
                                    : const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ShowWeather extends StatefulWidget {
  const ShowWeather({
    super.key,
    required this.weatherData,
    required this.locality,
  });

  final WeatherData weatherData;
  final String locality;

  @override
  State<ShowWeather> createState() => _ShowWeatherState();
}

class _ShowWeatherState extends State<ShowWeather> {
  @override
  Widget build(BuildContext context) {
    String cityName = widget.locality;
    double currTemp = widget.weatherData.current.temperature2M;
    String weatherDescription =
        widget.weatherData.current.weatherCode.getWeatherDesc();
    double maxTemp = widget.weatherData.daily.temperature2MMax.first;
    double minTemp = widget.weatherData.daily.temperature2MMin.first;
    const int nDaysForecast = 3;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// city name
        Padding(
          padding: const EdgeInsets.only(
            top: 24,
          ),
          child: Align(
            child: Text(
              cityName,
              style: GoogleFonts.questrial(
                color: Colors.black,
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        /// print today or date
        Padding(
          padding: const EdgeInsets.only(
            top: 12,
          ),
          child: Align(
            child: Text(
              'Today', //day
              style: GoogleFonts.questrial(
                color: Colors.black54,
                fontSize: 30,
              ),
            ),
          ),
        ),

        /// print current temperature
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48.0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Opacity(
                  opacity: 0.7,
                  child: widget.weatherData.current.weatherCode
                      .getWeatherImage()
                      .loadAssetImage(
                        height: 160,
                        width: 160,
                      ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '$currTemp˚C', //current temperature
                  style: GoogleFonts.questrial(
                    color: getColorForTemp(currTemp),
                    fontSize: 80,
                  ),
                ),
              ),
            ],
          ),
        ),

        /// print weather description
        Padding(
          padding: const EdgeInsets.only(
            top: 12,
          ),
          child: Align(
            child: Text(
              weatherDescription, // weather
              style: GoogleFonts.questrial(
                color: Colors.black54,
                fontSize: 30,
              ),
            ),
          ),
        ),

        /// print max/min of the day
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$minTemp˚C', // min temperature
                style: GoogleFonts.questrial(
                  color: getColorForTemp(minTemp),
                  fontSize: 20,
                ),
              ),
              Text(
                '/',
                style: GoogleFonts.questrial(
                    color: Colors.black54,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                '$maxTemp˚C', //max temperature
                style: GoogleFonts.questrial(
                  color: getColorForTemp(maxTemp),
                  fontSize: 22,
                ),
              ),
            ],
          ),
        ),

        /// forecast for next n days
        Padding(
          padding: const EdgeInsets.all(24),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
              color: Colors.white.withOpacity(0.05),
            ),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 12,
                    ),
                    child: Text(
                      '$nDaysForecast-day forecast',
                      style: GoogleFonts.questrial(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const Divider(color: Colors.black),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.weatherData.daily.weatherCode.length,
                  itemBuilder: (BuildContext context, int index) {
                    return buildNDayForecast(
                      // DateTime.parse("2024-02-09").getDayName(),
                      widget.weatherData.daily.time[index].getDayName(),
                      widget.weatherData.daily.temperature2MMin[index],
                      widget.weatherData.daily.temperature2MMax[index],
                      widget.weatherData.daily.weatherCode[index]
                          .getWeatherIcon(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildNDayForecast(
    String time,
    double minTemp,
    double maxTemp,
    IconData weatherIcon,
  ) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  time,
                  style: GoogleFonts.questrial(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 100,
                ),
                child: FaIcon(
                  weatherIcon,
                  color: Colors.black,
                  size: 20,
                ),
              ),
              Align(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 100,
                  ),
                  child: Text(
                    '$minTemp˚C',
                    style: GoogleFonts.questrial(
                      color: Colors.black38,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                  child: Text(
                    '$maxTemp˚C',
                    style: GoogleFonts.questrial(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Divider(color: Colors.black),
        ],
      ),
    );
  }

  getColorForTemp(double currTemp) {
    return currTemp <= 0
        ? Colors.blue
        : currTemp > 0 && currTemp <= 15
            ? Colors.indigo
            : currTemp > 15 && currTemp < 30
                ? Colors.green
                : currTemp > 30 && currTemp < 45
                    ? Colors.orange
                    : Colors.red;
  }
}
