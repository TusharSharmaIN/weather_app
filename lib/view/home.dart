import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import '../model/weather_data.dart';
import '../api/dio_service.dart';
import '../view_model/home_view_model.dart';

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //  weather description
            const Text(
              'Weather',
            ),
            const Image(
              image: AssetImage('assets/images/cloud.png'),
              height: 200,
              width: 200,
            ),
            Selector<HomeViewModel, Tuple3<bool, String, WeatherData?>>(
              selector: (_, viewModel) => Tuple3(
                viewModel.isLoading,
                viewModel.errorMessage,
                viewModel.weatherData,
              ),
              builder: (context, data, child) {
                return data.item1
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : data.item2.isNotEmpty
                        ? Center(
                            child: Text(data.item2),
                          )
                        : Text(
                            "Weather Data: ${data.item3.toString()}",
                          );
              },
            ),
          ],
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
