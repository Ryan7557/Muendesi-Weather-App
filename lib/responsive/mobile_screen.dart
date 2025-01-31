import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/backend/api_service.dart';
import 'package:weather_app/backend/weather_model.dart';
import 'package:weather_app/constants/constants.dart';
import 'package:intl/intl.dart';

import '../widget/error_widget.dart';
import '../widget/searchbar_widget.dart';

class MobileScreen extends StatefulWidget {
  const MobileScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeToogle,
  });
  final bool isDarkMode;
  final VoidCallback onThemeToogle;

  @override
  State<MobileScreen> createState() => _MobileScreenState();
}

class _MobileScreenState extends State<MobileScreen> {
  final WeatherService _weatherService = WeatherService();
  Weather? _weather;
  List<Forecast>? _forecast;
  String? _error;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocationWeather();
  }

  Future<void> _searchCity(String city) async {
    if (!mounted || city.isEmpty) return;

    try {
      final weather = await _weatherService.searchCityWeather(city);
      final forecast = await _weatherService.getForecastWeather(city);

      if (!mounted) return;

      setState(() {
        _weather = weather;
        _forecast = forecast;
      });
    } catch (e) {
      if (!mounted) return;
      throw Exception('Failed to fetch city weather: $e');
    }
  }

  Future<void> _getCurrentLocationWeather() async {
    if (!mounted) return;

    try {
      final weather = await _weatherService.getCurrentLocationWeather();
      final forecast = await _weatherService.getForecastWeather(weather.city);

      if (!mounted) return;

      setState(() {
        _weather = weather;
        _forecast = forecast;
      });
    } catch (e) {
      if (!mounted) return;
      throw Exception('Failed to fetch current location weather: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          WeatherSearchBar(
            isDarkMode: widget.isDarkMode,
            controller: _searchController,
            onSearch: _searchCity,
          ),
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                color: widget.isDarkMode ? Colors.yellow : Colors.black87),
            onPressed: widget.onThemeToogle,
          ),
        ],
      ),
      body: _error != null
          ? ErrorWidgetWarning(
              error: _error!,
              onRetry: _getCurrentLocationWeather,
              isDarkMode: widget.isDarkMode,
            )
          :
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Current Weather Section
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Weather Info
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_weather?.temperature.toString()}°C',
                          style: const TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          'Condition: ${_weather?.condition}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Text(
                              _weather?.city ?? 'Loading...',
                              style: const TextStyle(fontSize: 15),
                            ),
                            const SizedBox(width: 3),
                            const Icon(Icons.location_on, size: 18),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Weather Animation
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: 150,
                      child: Lottie.asset(
                        getWeatherAnimation(_weather?.condition),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: 320,
                child: Text(
                  'Weather forecast for your local city',
                ),
              ),
              const SizedBox(height: 10),
              // Forecast Section
              if (_forecast != null)
                SizedBox(
                  height: 320,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: _forecast!.take(5).length,
                    itemBuilder: (context, index) {
                      final forecast = _forecast!.take(5).toList()[index];
                      return ListTile(
                        leading: Lottie.asset(
                            getWeatherAnimation(forecast.condition)),
                        title: Text(
                          DateFormat('MMM d').format(forecast.date),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text(
                          "${forecast.temperature.toStringAsFixed(1)}°C - ${forecast.condition}",
                          style: TextStyle(
                            color: widget.isDarkMode
                                ? Colors.white70
                                : Colors.black54,
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
