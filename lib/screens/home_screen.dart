import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sky_pulse/providers/weather_provider.dart';
import 'package:sky_pulse/widgets/app_drawer.dart';
import 'package:sky_pulse/widgets/forecast_list.dart';
import 'package:sky_pulse/widgets/temperature_chart.dart';
import 'package:sky_pulse/widgets/weather_main_card.dart';
import 'package:sky_pulse/widgets/weather_search_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.transparent, // IMPORTANT
        elevation: 0, // optional (removes shadow for clean look)
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                // Color(0xFF0BA37F),
                Color(0xFF005E8A),
                Color(0xFF032D60),
              ],
            ),
          ),
        ),

        title: const Text(
          'Weatherly',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.white, // ensure visibility
          ),
        ),

        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            tooltip: 'Refresh',
            onPressed: () {
              final provider = context.read<WeatherProvider>();
              final currentCity = provider.weather?.cityName;
              if (currentCity == null) return;

              HapticFeedback.lightImpact();
              provider.fetchWeather(currentCity);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  backgroundColor: const Color(0xFF0B2A4A).withValues(alpha: 0.95),
                  content: const Text('Refreshing current city...'),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF032D60), Color(0xFF005E8A), Color(0xFF0BA37F)],
          ),
        ),
        child: SafeArea(
          child: Consumer<WeatherProvider>(
            builder: (context, provider, _) {
              return RefreshIndicator(
                color: Colors.white,
                backgroundColor: const Color(0xFF032D60),
                onRefresh: () async {
                  final currentCity = provider.weather?.cityName;
                  if (currentCity == null) return;
                  HapticFeedback.lightImpact();
                  await provider.fetchWeather(currentCity);
                },
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    WeatherSearchBar(
                      onSearch: (city) {
                        if (city.isNotEmpty) {
                          HapticFeedback.lightImpact();
                          provider.fetchWeather(city);
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    if (provider.isLoading)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      )
                    else if (provider.errorMessage != null)
                      Center(
                        child: Text(
                          provider.errorMessage!,
                          style: const TextStyle(color: Colors.white),
                        ),
                      )
                    else if (provider.weather != null)
                      AnimatedSlide(
                        duration: const Duration(milliseconds: 450),
                        offset: Offset.zero,
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 450),
                          opacity: 1,
                          child: Column(
                            children: [
                              WeatherMainCard(
                                weather: provider.weather!,
                                provider: provider,
                                isSaved: provider.isCitySaved(
                                  provider.weather!.cityName,
                                ),
                                onToggleSave: () async {
                                  final isSaved =
                                      await provider.toggleCurrentCitySaved();
                                  if (!context.mounted) return;
                                  HapticFeedback.selectionClick();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(duration:const Duration(seconds: 2),
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      backgroundColor: const Color(
                                        0xFF0B2A4A,
                                      ).withValues(alpha: 0.96),
                                      content: Text(
                                        isSaved
                                            ? 'City saved successfully'
                                            : 'City removed',
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 18),
                              ForecastList(
                                forecast: provider.weather!.forecast,
                                provider: provider,
                              ),
                              const SizedBox(height: 18),
                              TemperatureChart(
                                forecast: provider.weather!.forecast,
                                provider: provider,
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
