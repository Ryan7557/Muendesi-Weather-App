import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../backend/weather_model.dart';
import '../constants/constants.dart';

class ForecastList extends StatelessWidget {
  final List<Forecast>? forecast;
  final bool isDarkMode;

  const ForecastList({
    Key? key,
    required this.forecast,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: forecast?.take(5).length ?? 0,
        itemBuilder: (context, index) {
          final forecastItem = forecast!.take(5).toList()[index];
          return ListTile(
            leading: Lottie.asset(getWeatherAnimation(forecastItem.condition)),
            title: Text(
              DateFormat('MMM d').format(forecastItem.date),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Text(
              "${forecastItem.temperature.toStringAsFixed(1)}°C - ${forecastItem.condition}",
              style: TextStyle(
                color: isDarkMode ? Colors.white70 : Colors.black54,
              ),
            ),
          );
        },
      ),
    );
  }
}