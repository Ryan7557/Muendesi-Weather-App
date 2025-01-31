import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../backend/weather_model.dart';

class HourlyForecastList extends StatelessWidget {
  final List<HourlyForecast>? hourlyForecast;
  final bool isDarkMode;

  const HourlyForecastList({
    Key? key,
    required this.hourlyForecast,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: hourlyForecast?.take(8).length ?? 0,
        itemBuilder: (context, index) {
          final forecastItem = hourlyForecast!.take(8).toList()[index];
          return ListTile(
            leading: Image.network(
              "http://openweathermap.org/img/wn/${forecastItem.icon}@2x.png",
              width: 50,
              height: 50,
            ),
            title: Text(
              DateFormat('h a').format(forecastItem.date),
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