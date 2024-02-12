import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../constants/app_colors.dart';
import '../../../utils/extensions.dart';

class WeatherForToday extends StatelessWidget {
  const WeatherForToday({
    super.key,
    required this.times,
    required this.weatherCodes,
    required this.temperatures,
  });

  final List<String> times;
  final List<int> weatherCodes;
  final List<double> temperatures;
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
                        "Today",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 20,
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
                    times: times.sublist(0, hoursToDisplay),
                    weatherCodes: weatherCodes.sublist(0, hoursToDisplay),
                    temperatures: temperatures.sublist(0, hoursToDisplay),
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
  ItemScrollController itemScrollController = ItemScrollController();
  ItemPositionsListener itemPositionListener = ItemPositionsListener.create();

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.times.indexWhere(
      (element) => DateTime.parse(element).hour == DateTime.now().hour,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await itemScrollController.scrollTo(
        index: selectedIndex,
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: ScrollablePositionedList.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: widget.weatherCodes.length,
          itemPositionsListener: itemPositionListener,
          itemScrollController: itemScrollController,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.blueJeans,
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
                      widget.weatherCodes[index]
                          .getWeatherSvg(
                              isDay: DateTime.parse(widget.times[index])
                                  .checkIsDay())
                          .loadAssetSvg(height: 30, width: 30),
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
            );
          }),
    );
  }
}

/// this implementation was used to make the hourly view clickable
/// on tap border changes of the selected hour
// class HourlyWeather extends StatefulWidget {
//   const HourlyWeather({
//     super.key,
//     required this.times,
//     required this.weatherCodes,
//     required this.temperatures,
//   });
//
//   final List<String> times;
//   final List<int> weatherCodes;
//   final List<double> temperatures;
//
//   @override
//   State<HourlyWeather> createState() => _HourlyWeatherState();
// }
//
// class _HourlyWeatherState extends State<HourlyWeather> {
//   int selectedIndex = -1;
//
//   @override
//   void initState() {
//     super.initState();
//     selectedIndex = widget.times.indexWhere(
//         (element) => DateTime.parse(element).hour == DateTime.now().hour);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 140,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         shrinkWrap: true,
//         itemCount: widget.weatherCodes.length,
//         itemBuilder: (context, index) {
//           return Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 12.0),
//             child: GestureDetector(
//               onTap: () {
//                 setState(() {
//                   selectedIndex = index;
//                 });
//               },
//               child: Container(
//                 decoration: BoxDecoration(
//                   border: Border.all(
//                     color: AppColors.blueJeans,
//                     width: 2,
//                     style: selectedIndex == index
//                         ? BorderStyle.solid
//                         : BorderStyle.none,
//                   ),
//                   borderRadius: const BorderRadius.all(Radius.circular(12)),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     children: [
//                       Text(
//                         widget.temperatures[index].formatTempInC(),
//                         style: GoogleFonts.poppins(
//                           color: Colors.white,
//                           fontSize: 16,
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       widget.weatherCodes[index]
//                           .getWeatherSvg(
//                               isDay: DateTime.parse(widget.times[index])
//                                   .checkIsDay())
//                           .loadAssetSvg(height: 30, width: 30),
//                       const SizedBox(height: 16),
//                       Text(
//                         DateTime.parse(widget.times[index]).formatTime24H(),
//                         style: GoogleFonts.poppins(
//                           color: Colors.white,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
