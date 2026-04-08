class WeatherIconMapper {
  static String getIconAsset(String condition) {
    final normalized = condition.toLowerCase();
    if (normalized.contains('thunder')) return 'assets/weather_icons/storm.png';
    if (normalized.contains('rain') || normalized.contains('drizzle')) {
      return 'assets/weather_icons/rainy.png';
    }
    if (normalized.contains('snow')) return 'assets/weather_icons/snow.png';
    if (normalized.contains('mist') ||
        normalized.contains('fog') ||
        normalized.contains('haze')) {
      return 'assets/weather_icons/mist.png';
    }
    if (normalized.contains('cloud')) return 'assets/weather_icons/cloudy.png';
    return 'assets/weather_icons/sunny.png';
  }
}
