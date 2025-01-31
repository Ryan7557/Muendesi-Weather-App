class Weather {
  final String city;
  final double temperature;
  final String description;
  final String condition;

  Weather({
    required this.city,
    required this.temperature,
    required this.description,
    required this.condition,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      city: json['name'],
      temperature: json['main']['temp'].toDouble(),
      description: json['weather'][0]['description'],
      condition: json['weather'][0]['main'],
    );
  }
}

class Forecast {
  final DateTime date;
  final double temperature;
  final String condition;

  Forecast({
    required this.date,
    required this.temperature,
    required this.condition,
  });

  factory Forecast.fromJson(Map<String, dynamic> json, int dayOffset) {
    final currentDate = DateTime.now();
    final forecastDate = currentDate.add(Duration(days: dayOffset));

    return Forecast(
      date: DateTime(
        forecastDate.year,
        forecastDate.month,
        forecastDate.day,
        12,
      ),
      temperature: json['main']['temp'].toDouble(),
      condition: json['weather'][0]['main'],
    );
  }
}

class HourlyForecast {
  final DateTime date;
  final double temperature;
  final String condition;
  final String icon;

  HourlyForecast({
    required this.date,
    required this.temperature,
    required this.condition,
    required this.icon,
  });

  factory HourlyForecast.fromJson(Map<String, dynamic> json, int i) {
    return HourlyForecast(
      date: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      temperature: json['main']['temp'].toDouble(),
      condition: json['weather'][0]['main'],
      icon: json['weather'][0]['icon'],
    );
  }
}
