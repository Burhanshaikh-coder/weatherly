import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sky_pulse/providers/weather_provider.dart';
import 'package:sky_pulse/models/weather.dart';
import 'package:sky_pulse/utils/weather_icon_mapper.dart';
import 'package:sky_pulse/widgets/glass_card.dart';

class WeatherMainCard extends StatelessWidget {
  const WeatherMainCard({
    super.key,
    required this.weather,
    required this.onToggleSave,
    required this.isSaved,
    required this.provider,
  });

  final Weather weather;
  final VoidCallback onToggleSave;
  final bool isSaved;
  final WeatherProvider provider;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      weather.cityName,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      DateFormat('EEEE, MMM d').format(weather.date),
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onToggleSave,
                icon: AnimatedScale(
                  duration: const Duration(milliseconds: 240),
                  scale: isSaved ? 1.2 : 1.0,
                  curve: Curves.easeOutBack,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 260),
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          isSaved
                              ? Colors.redAccent.withValues(alpha: 0.14)
                              : Colors.transparent,
                      boxShadow:
                          isSaved
                              ? [
                                BoxShadow(
                                  color: Colors.redAccent.withValues(
                                    alpha: 0.45,
                                  ),
                                  blurRadius: 16,
                                  spreadRadius: 1,
                                ),
                              ]
                              : const [],
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 180),
                      transitionBuilder:
                          (child, animation) =>
                              ScaleTransition(scale: animation, child: child),
                      child: Icon(
                        isSaved
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        key: ValueKey<bool>(isSaved),
                        color: isSaved ? Colors.redAccent : Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Center(
            child: Image.asset(
              WeatherIconMapper.getIconAsset(weather.condition),
              height: 110,
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              '${provider.convertTemperature(weather.temperature).round()}°${provider.unitLabel}',
              style: const TextStyle(
                fontSize: 76,
                fontWeight: FontWeight.w300,
                color: Colors.white,
                height: 1,
              ),
            ),
          ),
          Center(
            child: Text(
              weather.condition,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _InfoChip(label: 'Humidity', value: '${weather.humidity}%'),
              _InfoChip(label: 'Wind', value: '${weather.windSpeed} m/s'),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.white.withValues(alpha: 0.85)),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
