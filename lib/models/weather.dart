import 'package:sky_pulse/models/forecast_day.dart';

class Weather {
  const Weather({
    required this.cityName,
    required this.date,
    required this.temperature,
    required this.condition,
    required this.humidity,
    required this.windSpeed,
    required this.forecast,
  });

  final String cityName;
  final DateTime date;
  final double temperature;
  final String condition;
  final int humidity;
  final double windSpeed;
  final List<ForecastDay> forecast;
}
