import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sky_pulse/models/forecast_day.dart';
import 'package:sky_pulse/providers/weather_provider.dart';
import 'package:sky_pulse/utils/weather_icon_mapper.dart';
import 'package:sky_pulse/widgets/glass_card.dart';

class ForecastList extends StatelessWidget {
  const ForecastList({
    super.key,
    required this.forecast,
    required this.provider,
  });

  final List<ForecastDay> forecast;
  final WeatherProvider provider;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth * 0.29).clamp(96.0, 122.0);

    return SizedBox(
      height: 156,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, index) {
          final day = forecast[index];
          return SizedBox(
            width: cardWidth,
            child: GlassCard(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(DateFormat('EEE').format(day.date)),
                  const SizedBox(height: 6),
                  Image.asset(
                    WeatherIconMapper.getIconAsset(day.condition),
                    width: 36,
                    height: 36,
                  ),
                  const SizedBox(height: 10),
                  Flexible(
                    child: Text(
                      '${provider.convertTemperature(day.maxTemp).round()}°${provider.unitLabel}\n'
                      '${provider.convertTemperature(day.minTemp).round()}°${provider.unitLabel}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        height: 1.15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemCount: forecast.length,
      ),
    );
  }
}
