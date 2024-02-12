import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class WeatherLoader extends StatelessWidget {
  const WeatherLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.black.withOpacity(0.05),
      highlightColor: Colors.black.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 24,
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                height: 20,
                width: 100,
                decoration: containerStyle(),
              ),
            ),
            const SizedBox(height: 32),
            Container(
              decoration: containerStyle(),
              height: 160,
              width: 200,
            ),
            const SizedBox(height: 32),
            Container(
              decoration: containerStyle(),
              height: 40,
              width: 200,
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                decoration: containerStyle(),
                height: 160,
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                decoration: containerStyle(),
                height: 160,
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  containerStyle() {
    return BoxDecoration(
      color: Colors.grey,
      borderRadius: BorderRadius.circular(6),
    );
  }
}
