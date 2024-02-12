import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';

import 'constants/app_theme.dart';
import 'show_weather/views/weather_view.dart';
import 'show_weather/view_models/weather_view_model.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<WeatherViewModel>(
          create: (context) =>
              WeatherViewModel(),
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
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const WeatherView(),
    );
  }
}
