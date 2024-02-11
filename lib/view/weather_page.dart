import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFf9b16e), Color(0xFFf68080)],
            ),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
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
                                  // ? ShowWeather(
                                  //     weatherData: weatherData,
                                  //     subLocality:
                                  //         homeViewModel.subLocality,
                                  //     locality: homeViewModel.locality,
                                  //   )
                                  ? ShowWeather2(
                                      weatherData: weatherData,
                                      subLocality: homeViewModel.subLocality,
                                      locality: homeViewModel.locality,
                                    )
                                  : const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ShowWeather2 extends StatefulWidget {
  const ShowWeather2({
    super.key,
    required this.weatherData,
    required this.subLocality,
    required this.locality,
  });

  final WeatherData weatherData;
  final String subLocality;
  final String locality;

  @override
  State<ShowWeather2> createState() => _ShowWeather2State();
}

class _ShowWeather2State extends State<ShowWeather2> {
  late String cityName;
  late double currTemp;
  late int weatherCode;
  late String weatherDescription;
  late double maxTemp;
  late double minTemp;
  late bool isDay;
  late int nDaysForecast;

  @override
  void initState() {
    super.initState();
    cityName = "${widget.subLocality}, ${widget.locality}";
    currTemp = widget.weatherData.current.temperature2M;
    weatherCode = widget.weatherData.current.weatherCode;
    weatherDescription =
        widget.weatherData.current.weatherCode.getWeatherDesc();
    maxTemp = widget.weatherData.daily.temperature2MMax.first;
    minTemp = widget.weatherData.daily.temperature2MMin.first;
    isDay = widget.weatherData.current.isDay == 1 ? true : false;
    nDaysForecast = 7;
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
          weatherCode.getWeatherSvg(isDay: isDay),
          height: 160,
        ),
        const SizedBox(height: 16),

        /// Temperature
        Text(
          currTemp.formatTempInC(),
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 36,
          ),
        ),
        const SizedBox(height: 8),

        /// weather description
        Text(
          weatherDescription,
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
              'min: ${minTemp.formatTempInC()}',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 20),
            Text(
              'max: ${maxTemp.formatTempInC()}',
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
        WeatherForToday(data: widget.weatherData),
        const SizedBox(height: 16),

        /// Next 7 day forecast
        WeatherForWeek(nDaysForecast: nDaysForecast, data: widget.weatherData),
      ],
    );
  }
}

class WeatherForToday extends StatelessWidget {
  const WeatherForToday({
    super.key,
    required this.data,
  });

  final WeatherData data;
  static const hoursToDisplay = 24;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
      ),
      child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(14)),
            color: const Color(0xBB104084).withOpacity(0.30),
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
                        "Today",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      //  date, month
                      Text(
                        DateTime.now().formatDate(),
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 12.0,
                  ),
                  child: HourlyWeather(
                    times: data.hourly.time.sublist(0, hoursToDisplay),
                    weatherCodes: data.hourly.weatherCode.sublist(0, hoursToDisplay),
                    temperatures: data.hourly.temperature2M.sublist(0, hoursToDisplay),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}

class HourlyWeather extends StatefulWidget {
  const HourlyWeather({
    super.key,
    required this.times,
    required this.weatherCodes,
    required this.temperatures,
  });

  final List<String> times;
  final List<int> weatherCodes;
  final List<double> temperatures;

  @override
  State<HourlyWeather> createState() => _HourlyWeatherState();
}

class _HourlyWeatherState extends State<HourlyWeather> {
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: widget.weatherCodes.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFF54C1FF),
                    width: 2,
                    style: selectedIndex == index
                        ? BorderStyle.solid
                        : BorderStyle.none,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        widget.temperatures[index].formatTempInC(),
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 16),
                      widget.weatherCodes[index].getWeatherSvg(isDay: DateTime.parse(widget.times[index]).checkIsDay()).loadAssetSvg(height: 30, width: 30),
                      const SizedBox(height: 16),
                      Text(
                        DateTime.parse(widget.times[index]).formatTime24H(),
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class WeatherForWeek extends StatelessWidget {
  const WeatherForWeek({
    super.key,
    required this.nDaysForecast,
    required this.data,
  });

  final int nDaysForecast;
  final WeatherData data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
      ),
      child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(14)),
            color: const Color(0xBB104084).withOpacity(0.30),
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
                    itemCount: data.daily.time.length,
                    itemBuilder: (BuildContext context, int index) {
                      return DailyWeather(
                        date: data.daily.time[index].getDayName(),
                        minTemp: data.daily.temperature2MMin[index],
                        maxTemp: data.daily.temperature2MMax[index],
                        weatherCode: data.daily.weatherCode[index],
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
          Text(
            date,
            style: GoogleFonts.questrial(
              color: Colors.white,
              fontSize: 18,
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

/// OLD WORKING CODE
// class ShowWeather extends StatefulWidget {
//   const ShowWeather({
//     super.key,
//     required this.weatherData,
//     required this.subLocality,
//     required this.locality,
//   });
//
//   final WeatherData weatherData;
//   final String subLocality;
//   final String locality;
//
//   @override
//   State<ShowWeather> createState() => _ShowWeatherState();
// }
//
// class _ShowWeatherState extends State<ShowWeather> {
//   @override
//   Widget build(BuildContext context) {
//     String area = widget.subLocality;
//     String cityName = widget.locality;
//     double currTemp = widget.weatherData.current.temperature2M;
//     String weatherDescription =
//         widget.weatherData.current.weatherCode.getWeatherDesc();
//     double maxTemp = widget.weatherData.daily.temperature2MMax.first;
//     double minTemp = widget.weatherData.daily.temperature2MMin.first;
//     const int nDaysForecast = 3;
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         /// city name
//         Padding(
//           padding: const EdgeInsets.only(
//             top: 24,
//           ),
//           child: Align(
//             child: Text(
//               "$area, $cityName",
//               style: GoogleFonts.questrial(
//                 color: Colors.black,
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ),
//
//         /// print today or date
//         Padding(
//           padding: const EdgeInsets.only(
//             top: 12,
//           ),
//           child: Align(
//             child: Text(
//               'Today', //day
//               style: GoogleFonts.questrial(
//                 color: Colors.black54,
//                 fontSize: 30,
//               ),
//             ),
//           ),
//         ),
//
//         /// print current temperature
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 48.0),
//           child: Stack(
//             alignment: Alignment.center,
//             children: [
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: Opacity(
//                   opacity: 0.7,
//                   child: widget.weatherData.current.weatherCode
//                       .getWeatherImage()
//                       .loadAssetImage(
//                         height: 160,
//                         width: 160,
//                       ),
//                 ),
//               ),
//               Align(
//                 alignment: Alignment.centerRight,
//                 child: Text(
//                   '$currTemp˚C', //current temperature
//                   style: GoogleFonts.questrial(
//                     color: getColorForTemp(currTemp),
//                     fontSize: 80,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//
//         /// print weather description
//         Padding(
//           padding: const EdgeInsets.only(
//             top: 12,
//           ),
//           child: Align(
//             child: Text(
//               weatherDescription, // weather
//               style: GoogleFonts.questrial(
//                 color: Colors.black54,
//                 fontSize: 30,
//               ),
//             ),
//           ),
//         ),
//
//         /// print max/min of the day
//         Padding(
//           padding: const EdgeInsets.symmetric(vertical: 16),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 '$minTemp˚C', // min temperature
//                 style: GoogleFonts.questrial(
//                   color: getColorForTemp(minTemp),
//                   fontSize: 20,
//                 ),
//               ),
//               Text(
//                 '/',
//                 style: GoogleFonts.questrial(
//                     color: Colors.black54,
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold),
//               ),
//               Text(
//                 '$maxTemp˚C', //max temperature
//                 style: GoogleFonts.questrial(
//                   color: getColorForTemp(maxTemp),
//                   fontSize: 22,
//                 ),
//               ),
//             ],
//           ),
//         ),
//
//         /// forecast for next n days
//         Padding(
//           padding: const EdgeInsets.all(24),
//           child: Container(
//             decoration: BoxDecoration(
//               borderRadius: const BorderRadius.all(
//                 Radius.circular(10),
//               ),
//               color: Colors.white.withOpacity(0.05),
//             ),
//             child: Column(
//               children: [
//                 Align(
//                   alignment: Alignment.centerLeft,
//                   child: Padding(
//                     padding: const EdgeInsets.only(
//                       left: 12,
//                     ),
//                     child: Text(
//                       '$nDaysForecast-day forecast',
//                       style: GoogleFonts.questrial(
//                         color: Colors.black,
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const Divider(color: Colors.black),
//                 ListView.builder(
//                   shrinkWrap: true,
//                   itemCount: widget.weatherData.daily.weatherCode.length,
//                   itemBuilder: (BuildContext context, int index) {
//                     return buildNDayForecast(
//                       widget.weatherData.daily.time[index].getDayName(),
//                       widget.weatherData.daily.temperature2MMin[index],
//                       widget.weatherData.daily.temperature2MMax[index],
//                       widget.weatherData.daily.weatherCode[index]
//                           .getWeatherIcon(),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget buildNDayForecast(
//     String time,
//     double minTemp,
//     double maxTemp,
//     IconData weatherIcon,
//   ) {
//     return Padding(
//       padding: const EdgeInsets.all(4),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Stack(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 8),
//                 child: Text(
//                   time,
//                   style: GoogleFonts.questrial(
//                     color: Colors.black,
//                     fontSize: 18,
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 100,
//                 ),
//                 child: FaIcon(
//                   weatherIcon,
//                   color: Colors.black,
//                   size: 20,
//                 ),
//               ),
//               Align(
//                 child: Padding(
//                   padding: const EdgeInsets.only(
//                     left: 100,
//                   ),
//                   child: Text(
//                     '$minTemp˚C',
//                     style: GoogleFonts.questrial(
//                       color: Colors.black38,
//                       fontSize: 20,
//                     ),
//                   ),
//                 ),
//               ),
//               Align(
//                 alignment: Alignment.centerRight,
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 8,
//                   ),
//                   child: Text(
//                     '$maxTemp˚C',
//                     style: GoogleFonts.questrial(
//                       color: Colors.black,
//                       fontSize: 20,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const Divider(color: Colors.black),
//         ],
//       ),
//     );
//   }
//
//   getColorForTemp(double currTemp) {
//     return currTemp <= 0
//         ? Colors.blue
//         : currTemp > 0 && currTemp <= 15
//             ? Colors.indigo
//             : currTemp > 15 && currTemp < 30
//                 ? Colors.green
//                 : currTemp > 30 && currTemp < 45
//                     ? Colors.orange
//                     : Colors.red;
//   }
// }
