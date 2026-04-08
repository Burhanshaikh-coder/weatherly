import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sky_pulse/providers/weather_provider.dart';
import 'package:sky_pulse/screens/about_screen.dart';
import 'package:sky_pulse/screens/home_screen.dart';
import 'package:sky_pulse/screens/saved_cities_screen.dart';
import 'package:sky_pulse/screens/settings_screen.dart';
import 'package:sky_pulse/services/storage_service.dart';
import 'package:sky_pulse/services/weather_service.dart';
import 'package:sky_pulse/utils/app_theme.dart';

void main() {
  runApp(const SmartWeatherApp());
}

class SmartWeatherApp extends StatelessWidget {
  const SmartWeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create:
              (_) => WeatherProvider(
                weatherService: WeatherService(),
                storageService: StorageService(),
              )..fetchWeather('Mumbai'),
        ),
      ],
      child: MaterialApp(
        title: 'Weatherly',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        initialRoute: '/',
        routes: {
          '/': (_) => const HomeScreen(),
          '/saved': (_) => const SavedCitiesScreen(),
          '/settings': (_) => const SettingsScreen(),
          '/about': (_) => const AboutScreen(),
        },
      ),
    );
  }
}
