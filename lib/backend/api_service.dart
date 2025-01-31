import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/backend/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  Future<Weather> getCurrentLocationWeather() async {
    try {
      Position position = await getCurrentLocation();

      Weather weather = await fetchWeatherData(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      return weather;
    } catch (e) {
      throw Exception('Failed to fetch current location weather: $e');
    }
  }

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location service is disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(
      // ignore: deprecated_member_use
      desiredAccuracy: LocationAccuracy.best,
    );
  }

  Future<Weather> searchCityWeather(String cityName) async {
    try {
      Weather weather = await fetchWeatherData(cityName: cityName);
      return weather;
    } catch (e) {
      throw Exception('Failed to fetch city weather: $e');
    }
  }

  Future<Weather> fetchWeatherData({
    double? latitude,
    double? longitude,
    String? cityName,
  }) async {
    final String apiKey = dotenv.env['API_KEY']!;
    String apiUrl;

    if (cityName != null) {
      // Fetch weather data by city name
      apiUrl =
          "https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric";
    } else if (latitude != null && longitude != null) {
      // Fetch weather data by latitude and longitude
      apiUrl =
          "https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric";
    } else {
      throw Exception(
          "Either city name or latitude and longitude must be provided.");
    }

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Weather.fromJson(data);
    } else {
      throw Exception('Failed to fetch weather data: ${response.statusCode}');
    }
  }

  Future<List<Forecast>> getForecastWeather(String city) async {
    final String apiKey = dotenv.env['API_KEY']!;
    final String apiUrl =
        'https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$apiKey&units=metric';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List.generate(5, (index) {
        return Forecast.fromJson(data['list'][index], index + 1);
      });
    } else {
      throw Exception('Failed to fetch forecast data: ${response.statusCode}');
    }
  }

  Future<List<HourlyForecast>> fetchHourlyForecast(String city) async {
    final String apiKey = dotenv.env['API_KEY']!;
    final String apiUrl =
        'https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$apiKey&units=metric';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List.generate(5, (index) {
        return HourlyForecast.fromJson(data['list'][index], index + 1);
      });
    } else {
      throw Exception('Failed to fetch forecast data: ${response.statusCode}');
    }
  }
}
