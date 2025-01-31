import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/widget/forecast_list.dart';

import '../backend/api_service.dart';
import '../backend/weather_model.dart';
import '../constants/constants.dart';
import '../widget/error_widget.dart';
import '../widget/searchbar_widget.dart';

class TabletScreen extends StatefulWidget {
  const TabletScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeToogle,
  });
  final bool isDarkMode;
  final VoidCallback onThemeToogle;

  @override
  State<TabletScreen> createState() => _TabletScreenState();
}

class _TabletScreenState extends State<TabletScreen> {
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
      final forecast = await _weatherService.getForecastWeather(city);
      setState(() {
        _weather = weather;
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

      final forecast = await _weatherService.getForecastWeather(weather.city);
      if (!mounted) return;

      setState(() {
        _weather = weather;
        _forecast = forecast;
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
          WeatherSearchBar(
            isDarkMode: widget.isDarkMode,
            controller: _searchController,
            onSearch: _searchCity,
          ),
          IconButton(
            icon: Icon(
              widget.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: widget.isDarkMode ? Colors.yellow : Colors.black87,
            ),
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
          : Row(
              children: [
                Container(
                  width: 300,
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
                            forecast: _forecast, isDarkMode: widget.isDarkMode),
                    ],
                  ),
                ),
                SizedBox(width: 55),
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: widget.isDarkMode ? Colors.black : Colors.white,
                    ),
                    height: 300,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Image.asset(
                              getBackgroundImage(_weather?.condition),
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.black.withOpacity(0.4),
                              ),
                            ),
                          ),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '${_weather?.temperature.toString()}°C',
                                  style: const TextStyle(
                                    fontSize: 35,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Text(
                                  'Condition: ${_weather?.condition}',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      _weather?.city ?? 'Loading...',
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 3),
                                    const Icon(
                                      Icons.location_on,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: SizedBox(
                      height: 150,
                      child: Lottie.asset(
                        getWeatherAnimation(_weather?.condition),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
