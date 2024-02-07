import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import '../model/weather_data.dart';
import '../api/dio_service.dart';
import '../view_model/home_view_model.dart';
import '../utils/extensions.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.title});

  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final WeatherData weatherObj;
  final DioService dioService = DioService();
  late final HomeViewModel homeViewModel;

  @override
  void initState() {
    super.initState();
    homeViewModel = context.read<HomeViewModel>();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await homeViewModel.fetchWeatherData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
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
                          : Column(
                              children: [
                                //  rest body
                                weatherData != null
                                    ? weatherData.current.weatherCode.getWeatherDesc().loadAssetImage()
                                    : const SizedBox.shrink(),
                                const SizedBox(height: 24),
                                Text(
                                  "Weather Data: ${homeViewModel.weatherData?.toJson().toString()}",
                                )
                              ],
                            );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          homeViewModel.fetchWeatherData();
        },
        tooltip: 'Get Weather',
        child: const Icon(Icons.refresh),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}