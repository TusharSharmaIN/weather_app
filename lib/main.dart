import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'view/weather_page.dart';
import 'api/dio_service.dart';
import 'repository/weather_repository.dart';
import 'view_model/home_view_model.dart';

void main() {
  // final Dio dio = Dio();
  final DioService dioService = DioService();
  final WeatherRepository weatherRepository = WeatherRepository(
    dioService: dioService,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<HomeViewModel>(
          create: (context) =>
              HomeViewModel(weatherRepository: weatherRepository),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const title = "Weather App";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const WeatherPage(),
    );
  }
}
