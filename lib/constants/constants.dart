import 'package:flutter/material.dart';

class Breakpoints {
  static const double mobile = 600;
  static const double tablet = 1100;
}

final lightTheme = ThemeData(
  brightness: Brightness.light,
  appBarTheme: const AppBarTheme(
    foregroundColor: Colors.white,
  ),
  iconTheme: const IconThemeData(
    color: Colors.black87,
    size: 24,
  ),
  iconButtonTheme: IconButtonThemeData(
    style: ButtonStyle(
        iconColor: WidgetStateProperty.resolveWith((states) => Colors.black45)),
  ),
);

final darkTheme = ThemeData(
    brightness: Brightness.dark,
    appBarTheme: AppBarTheme(
      foregroundColor: Colors.white,
    ),
    searchBarTheme: SearchBarThemeData(
        backgroundColor:
            WidgetStateColor.resolveWith((states) => Colors.white)));

String getWeatherAnimation(String? condition) {
  if (condition == null) {
    return 'assets/sunny.json';
  }
  switch (condition.toLowerCase()) {
    case 'clouds':
    case 'mist':
    case 'smoke':
    case 'haze':
    case 'dust':
    case 'fog':
      return 'assets/cloud.json';
    case 'rain':
    case 'drizzle':
    case 'shower rain':
      return 'assets/rainy.json';
    case 'thunderstorm':
      return 'assets/thunder';
    case 'clear':
      return 'assets/sunny.json';
    default:
      return 'assets/sunny.json';
  }
}

String getBackgroundImage(String? condition) {
  if (condition == null) return 'assets/clear.jpg';

  switch (condition.toLowerCase()) {
    case 'clouds':
    case 'mist':
    case 'smoke':
    case 'haze':
    case 'dust':
    case 'fog':
      return 'assets/cloudy.jpg';
    case 'rain':
    case 'drizzle':
    case 'shower rain':
      return 'assets/rainy.jpg';
    case 'thunderstorm':
      return 'assets/thunder.jpg';
    case 'clear':
      return 'assets/clear.jpg';
    default:
      return 'assets/clear.jpg';
  }
}
