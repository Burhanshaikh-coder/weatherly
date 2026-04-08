import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sky_pulse/models/weather.dart';
import 'package:sky_pulse/services/storage_service.dart';
import 'package:sky_pulse/services/weather_service.dart';

enum TemperatureUnit { celsius, fahrenheit }

class WeatherProvider extends ChangeNotifier {
  WeatherProvider({
    required WeatherService weatherService,
    required StorageService storageService,
  }) : _weatherService = weatherService,
       _storageService = storageService {
    loadSavedCities();
    loadTemperatureUnit();
  }

  final WeatherService _weatherService;
  final StorageService _storageService;

  Weather? _weather;
  bool _isLoading = false;
  String? _errorMessage;
  List<String> _savedCities = <String>[];
  TemperatureUnit _temperatureUnit = TemperatureUnit.celsius;

  Weather? get weather => _weather;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<String> get savedCities => _savedCities;
  TemperatureUnit get temperatureUnit => _temperatureUnit;
  String get unitLabel =>
      _temperatureUnit == TemperatureUnit.celsius ? 'C' : 'F';

  Future<void> fetchWeather(String cityName) async {
    // We expose loading/error states so UI can show loader and friendly messages.
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _weather = await _weatherService.fetchWeatherByCity(cityName);
    } on SocketException {
      _errorMessage = 'No internet connection';
    } on HttpException catch (e) {
      if (e.message.contains('City not found')) {
        _errorMessage = 'City not found';
      } else if (e.message.contains('Invalid API key')) {
        _errorMessage = 'Invalid API key';
      } else {
        _errorMessage = 'Unable to load weather data';
      }
    } catch (_) {
      _errorMessage = 'Unable to load weather data';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> saveCurrentCity() async {
    // Save the currently loaded city and return whether it was newly added.
    final city = _weather?.cityName;
    if (city == null) return false;
    final isSaved = await _storageService.saveCity(city);
    await loadSavedCities();
    return isSaved;
  }

  bool isCitySaved(String cityName) {
    return _savedCities.any(
      (city) => city.toLowerCase().trim() == cityName.toLowerCase().trim(),
    );
  }

  Future<bool> toggleCurrentCitySaved() async {
    final city = _weather?.cityName;
    if (city == null) return false;
    if (isCitySaved(city)) {
      await _storageService.removeCity(city);
      await loadSavedCities();
      return false;
    }
    await _storageService.saveCity(city);
    await loadSavedCities();
    return true;
  }

  Future<bool> deleteSavedCity(String cityName) async {
    final deleted = await _storageService.removeCity(cityName);
    if (deleted) {
      await loadSavedCities();
    }
    return deleted;
  }

  Future<void> setTemperatureUnit(TemperatureUnit unit) async {
    _temperatureUnit = unit;
    await _storageService.saveTemperatureUnit(unit.name);
    notifyListeners();
  }

  Future<void> loadTemperatureUnit() async {
    final unit = await _storageService.getTemperatureUnit();
    _temperatureUnit =
        unit == TemperatureUnit.fahrenheit.name
            ? TemperatureUnit.fahrenheit
            : TemperatureUnit.celsius;
    notifyListeners();
  }

  double convertTemperature(double celsiusTemp) {
    if (_temperatureUnit == TemperatureUnit.fahrenheit) {
      return (celsiusTemp * 9 / 5) + 32;
    }
    return celsiusTemp;
  }

  Future<void> loadSavedCities() async {
    _savedCities = await _storageService.getSavedCities();
    notifyListeners();
  }
}
