import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:sky_pulse/models/forecast_day.dart';
import 'package:sky_pulse/models/weather.dart';
import 'package:sky_pulse/utils/constants.dart';

class WeatherService {
  Future<Weather> fetchWeatherByCity(String cityName) async {
    final currentUri = Uri.https(
      'api.openweathermap.org',
      '/data/2.5/weather',
      {'q': cityName, 'appid': AppConstants.apiKey, 'units': 'metric'},
    );

    final currentResponse = await http.get(currentUri);
    if (currentResponse.statusCode == 404) {
      throw const HttpException('City not found');
    }
    if (currentResponse.statusCode == 401) {
      throw const HttpException('Invalid API key');
    }
    if (currentResponse.statusCode != 200) {
      throw const HttpException('Unable to fetch weather');
    }

    final currentData =
        jsonDecode(currentResponse.body) as Map<String, dynamic>;
    final lat = (currentData['coord']['lat'] as num).toDouble();
    final lon = (currentData['coord']['lon'] as num).toDouble();

    final forecastUri = Uri.https(
      'api.openweathermap.org',
      '/data/2.5/forecast',
      {
        'lat': '$lat',
        'lon': '$lon',
        'appid': AppConstants.apiKey,
        'units': 'metric',
      },
    );
    final forecastResponse = await http.get(forecastUri);
    if (forecastResponse.statusCode == 401) {
      throw const HttpException('Invalid API key');
    }
    if (forecastResponse.statusCode != 200) {
      throw const HttpException('Unable to fetch forecast');
    }
    final forecastData =
        jsonDecode(forecastResponse.body) as Map<String, dynamic>;

    return Weather(
      cityName: currentData['name'] as String,
      date: DateTime.now(),
      temperature: (currentData['main']['temp'] as num).toDouble(),
      condition: currentData['weather'][0]['main'] as String,
      humidity: (currentData['main']['humidity'] as num).toInt(),
      windSpeed: (currentData['wind']['speed'] as num).toDouble(),
      forecast: _buildDailyForecast(forecastData),
    );
  }

  List<ForecastDay> _buildDailyForecast(Map<String, dynamic> data) {
    final rawList =
        (data['list'] as List<dynamic>).cast<Map<String, dynamic>>();
    final grouped = <String, List<Map<String, dynamic>>>{};

    // The API sends forecast data in 3-hour chunks, so group records by day.
    for (final item in rawList) {
      final date = DateTime.fromMillisecondsSinceEpoch(
        (item['dt'] as int) * 1000,
      );
      final key = '${date.year}-${date.month}-${date.day}';
      grouped.putIfAbsent(key, () => []).add(item);
    }

    final days = <ForecastDay>[];
    for (final key in grouped.keys.take(7)) {
      final dayEntries = grouped[key]!;
      final minTemp = dayEntries
          .map((e) => (e['main']['temp_min'] as num).toDouble())
          .reduce((a, b) => a < b ? a : b);
      final maxTemp = dayEntries
          .map((e) => (e['main']['temp_max'] as num).toDouble())
          .reduce((a, b) => a > b ? a : b);

      // Pick a midday data point for each day to show a stable condition icon.
      final middayEntry = dayEntries.firstWhere((entry) {
        final time = DateTime.fromMillisecondsSinceEpoch(
          (entry['dt'] as int) * 1000,
        );
        return time.hour >= 12 && time.hour <= 15;
      }, orElse: () => dayEntries.first);

      final apiDate = DateTime.parse(dayEntries.first['dt_txt'] as String);
      days.add(
        ForecastDay(
          date: DateTime(apiDate.year, apiDate.month, apiDate.day),
          minTemp: minTemp,
          maxTemp: maxTemp,
          condition: middayEntry['weather'][0]['main'] as String,
        ),
      );
    }

    // OpenWeather 5-day API can return fewer than 7 daily buckets; pad for UI.
    while (days.length < 7 && days.isNotEmpty) {
      final last = days.last;
      days.add(
        ForecastDay(
          date: last.date.add(const Duration(days: 1)),
          minTemp: last.minTemp,
          maxTemp: last.maxTemp,
          condition: last.condition,
        ),
      );
    }

    return days;
  }
}
