import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sky_pulse/models/forecast_day.dart';
import 'package:sky_pulse/providers/weather_provider.dart';
import 'package:sky_pulse/widgets/glass_card.dart';

class TemperatureChart extends StatelessWidget {
  const TemperatureChart({
    super.key,
    required this.forecast,
    required this.provider,
  });

  final List<ForecastDay> forecast;
  final WeatherProvider provider;

  @override
  Widget build(BuildContext context) {
    if (forecast.isEmpty) {
      return const GlassCard(
        child: SizedBox(
          height: 220,
          child: Center(child: Text('No chart data available')),
        ),
      );
    }

    final minSpots =
        forecast.asMap().entries.map((entry) {
          return FlSpot(
            entry.key.toDouble(),
            provider.convertTemperature(entry.value.minTemp),
          );
        }).toList();

    final maxSpots =
        forecast.asMap().entries.map((entry) {
          return FlSpot(
            entry.key.toDouble(),
            provider.convertTemperature(entry.value.maxTemp),
          );
        }).toList();

    final allValues = [
      ...minSpots.map((e) => e.y),
      ...maxSpots.map((e) => e.y),
    ];
    final minY = allValues.reduce((a, b) => a < b ? a : b) - 2;
    final maxY = allValues.reduce((a, b) => a > b ? a : b) + 2;

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Temperature Trend (°${provider.unitLabel})',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 220,
            child: LineChart(
              LineChartData(
                minY: minY,
                maxY: maxY,
                lineTouchData: LineTouchData(
                  handleBuiltInTouches: true,
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (_) => const Color(0xFF0F2747),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 4,
                  getDrawingHorizontalLine:
                      (_) => FlLine(
                        color: Colors.white.withValues(alpha: 0.2),
                        strokeWidth: 1,
                      ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.25),
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 34,
                      getTitlesWidget:
                          (value, meta) => Text(
                            value.toStringAsFixed(0),
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                            ),
                          ),
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= forecast.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            DateFormat('EEE').format(forecast[index].date),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: minSpots,
                    isCurved: true,
                    barWidth: 3,
                    color: const Color(0xFF58B2FF),
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color(0xFF58B2FF).withValues(alpha: 0.3),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  LineChartBarData(
                    spots: maxSpots,
                    isCurved: true,
                    barWidth: 3,
                    color: const Color(0xFFFFA94D),
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Row(
            children: [
              _LegendDot(color: Color(0xFF58B2FF), label: 'Min temp'),
              SizedBox(width: 18),
              _LegendDot(color: Color(0xFFFFA94D), label: 'Max temp'),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.white70),
        ),
      ],
    );
  }
}
