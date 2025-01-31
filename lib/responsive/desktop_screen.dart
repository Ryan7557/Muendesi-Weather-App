import 'package:flutter/material.dart';
import 'package:weather_app/widget/error_widget.dart';
import 'package:weather_app/widget/forecast_list.dart';
import 'package:weather_app/widget/hourly_forecast.dart';
import 'package:weather_app/widget/weather_info_card.dart';

import '../backend/api_service.dart';
import '../backend/weather_model.dart';
import '../widget/searchbar_widget.dart';

class DesktopScreen extends StatefulWidget {
  const DesktopScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeToogle,
  });
  final bool isDarkMode;
  final VoidCallback onThemeToogle;

  @override
  State<DesktopScreen> createState() => _DesktopScreenState();
}

class _DesktopScreenState extends State<DesktopScreen> {
  final WeatherService _weatherService = WeatherService();
  Weather? _weather;
  List<Forecast>? _forecast;
  List<HourlyForecast>? _hourlyForecast;
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getCurrentLocationWeather();
    });
  }

  Future<void> _searchCity(String city) async {
    if (city.isEmpty) return;

    setState(() {
      _error = null;
    });

    try {
      final weather = await _weatherService.searchCityWeather(city);
      final hourlyForecast = await _weatherService.fetchHourlyForecast(city);
      final forecast = await _weatherService.getForecastWeather(city);
      setState(() {
        _weather = weather;
        _hourlyForecast = hourlyForecast;
        _forecast = forecast;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
      });
    }
  }

  Future<void> _getCurrentLocationWeather() async {
    if (!mounted) return;

    setState(() {
      _error = null;
    });

    try {
      final weather = await _weatherService.getCurrentLocationWeather();
      if (!mounted) return;

      final hourlyForecast =
          await _weatherService.fetchHourlyForecast(weather.city);
      if (!mounted) return;

      final forecast = await _weatherService.getForecastWeather(weather.city);
      if (!mounted) return;

      setState(() {
        _weather = weather;
        _forecast = forecast;
        _hourlyForecast = hourlyForecast;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          SizedBox(height: 50),
          WeatherSearchBar(
            isDarkMode: widget.isDarkMode,
            controller: _searchController,
            onSearch: _searchCity,
          ),
          SizedBox(width: 10),
          IconButton(
            icon: Icon(
              widget.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: widget.isDarkMode ? Colors.yellow : Colors.black87,
              size: 35,
            ),
            onPressed: widget.onThemeToogle,
          ),
          SizedBox(width: 10),
        ],
      ),
      body: _error != null
          ? ErrorWidgetWarning(
              error: _error!,
              onRetry: _getCurrentLocationWeather,
              isDarkMode: widget.isDarkMode,
            )
          : Row(
              children: [
                Container(
                  width: 250,
                  height: double.infinity,
                  padding: EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Weather forecast for your local city'),
                      SizedBox(height: 10),
                      if (_forecast != null)
                        ForecastList(
                          forecast: _forecast,
                          isDarkMode: widget.isDarkMode,
                        ),
                    ],
                  ),
                ),
                SizedBox(width: 100),
                Expanded(
                  // flex: ,
                  child: WeatherInfoCard(
                    weather: _weather,
                    isDarkMode: widget.isDarkMode,
                  ),
                ),
                // SizedBox(width: 50),
                Container(
                  width: 400,
                  height: double.infinity,
                  padding: EdgeInsets.all(28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Hourly Forecast'),
                      SizedBox(height: 10),
                      if (_hourlyForecast != null)
                        HourlyForecastList(
                          hourlyForecast: _hourlyForecast,
                          isDarkMode: widget.isDarkMode,
                        ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
