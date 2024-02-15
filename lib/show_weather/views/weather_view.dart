import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import '../../constants/app_colors.dart';
import '../models/weather_data.dart';
import '../view_models/weather_view_model.dart';
import 'widgets/weather_loader.dart';
import 'widgets/show_weather.dart';

class WeatherView extends StatefulWidget {
  const WeatherView({super.key});

  @override
  State<WeatherView> createState() => _WeatherViewState();
}

class _WeatherViewState extends State<WeatherView> {
  late final WeatherData weatherObj;
  late final WeatherViewModel weatherViewModel;

  // String day1 =
  //     "https://images.pexels.com/photos/2812185/pexels-photo-2812185.jpeg";
  // String night1 =
  //     "https://images.pexels.com/photos/8650161/pexels-photo-8650161.jpeg";
  // String night2 =
  //     "https://images.pexels.com/photos/2775580/pexels-photo-2775580.jpeg";
  // String night3 =
  //     "https://images.pexels.com/photos/7053441/pexels-photo-7053441.jpeg";

  @override
  void initState() {
    super.initState();
    weatherViewModel = context.read<WeatherViewModel>();
    FlutterNativeSplash.remove();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await weatherViewModel.initData(args: "init");
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await weatherViewModel.fetchWeatherData();
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  /// for background image
                  // image: DecorationImage(
                  //   fit: BoxFit.cover,
                  //   image: NetworkImage(night1),
                  // ),

                  /// for gradient
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppColors.veryLightTangelo, AppColors.lightCoral],
                  ),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: Selector<WeatherViewModel, Tuple2<bool, String>>(
                    selector: (_, viewModel) => Tuple2(
                      viewModel.isLoading,
                      viewModel.errorMessage,
                    ),
                    builder: (context, data, child) {
                      WeatherData? weatherData = weatherViewModel.weatherData;
                      return data.item1
                          ? const WeatherLoader()
                          : data.item2.isNotEmpty
                              ? Center(
                                  //  show error
                                  child: Text(data.item2),
                                )
                              : weatherData != null
                                  ? ShowWeather(
                                      subLocality: weatherViewModel.subLocality,
                                      locality: weatherViewModel.locality,
                                      currTemp: weatherData.current.temperature2M,
                                      weatherCode:
                                          weatherData.current.weatherCode,
                                      maxTemp: weatherData
                                          .daily.temperature2MMax.first,
                                      minTemp: weatherData
                                          .daily.temperature2MMin.first,
                                      isDay: weatherData.current.isDay == 1
                                          ? true
                                          : false,
                                      hourlyTimes: weatherData.hourly.time,
                                      hourlyWeatherCodes:
                                          weatherData.hourly.weatherCode,
                                      hourlyTemperatures:
                                          weatherData.hourly.temperature2M,
                                      weekDates: weatherData.daily.time,
                                      weekWeatherCodes:
                                          weatherData.daily.weatherCode,
                                      weekMinTemps:
                                          weatherData.daily.temperature2MMin,
                                      weekMaxTemps:
                                          weatherData.daily.temperature2MMax,
                                    )
                                  : const SizedBox.shrink();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
