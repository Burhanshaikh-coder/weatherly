import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const _savedCitiesKey = 'saved_cities';
  static const _temperatureUnitKey = 'temperature_unit';

  Future<List<String>> getSavedCities() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_savedCitiesKey) ?? <String>[];
  }

  Future<bool> saveCity(String cityName) async {
    final prefs = await SharedPreferences.getInstance();
    final cities = prefs.getStringList(_savedCitiesKey) ?? <String>[];
    final exists = cities.any(
      (city) => city.toLowerCase().trim() == cityName.toLowerCase().trim(),
    );
    if (exists) {
      return false;
    }
    cities.add(cityName.trim());
    await prefs.setStringList(_savedCitiesKey, cities);
    return true;
  }

  Future<bool> removeCity(String cityName) async {
    final prefs = await SharedPreferences.getInstance();
    final cities = prefs.getStringList(_savedCitiesKey) ?? <String>[];
    final updated =
        cities
            .where(
              (city) =>
                  city.toLowerCase().trim() != cityName.toLowerCase().trim(),
            )
            .toList();
    final removed = updated.length != cities.length;
    if (removed) {
      await prefs.setStringList(_savedCitiesKey, updated);
    }
    return removed;
  }

  Future<void> saveTemperatureUnit(String unit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_temperatureUnitKey, unit);
  }

  Future<String> getTemperatureUnit() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_temperatureUnitKey) ?? 'celsius';
  }
}
