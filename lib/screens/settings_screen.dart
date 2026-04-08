import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sky_pulse/providers/weather_provider.dart';
import 'package:sky_pulse/widgets/app_drawer.dart';
import 'package:sky_pulse/widgets/glass_card.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherProvider>();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.pushReplacementNamed(context, '/');
      },
      child: Scaffold(
        drawer: const AppDrawer(),
        appBar: AppBar(
          flexibleSpace: const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF032D60),
                  Color(0xFF005E8A),
                  Color(0xFF0BA37F),
                ],
              ),
            ),
          ),
          title: const Text('Settings'),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF032D60), Color(0xFF005E8A), Color(0xFF0BA37F)],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Temperature Unit',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Apply instantly across weather cards and chart',
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 14),
                  SegmentedButton<TemperatureUnit>(
                    showSelectedIcon: false,
                    segments: const [
                      ButtonSegment<TemperatureUnit>(
                        value: TemperatureUnit.celsius,
                        label: Text('Celsius (°C)'),
                        icon: Icon(Icons.thermostat),
                      ),
                      ButtonSegment<TemperatureUnit>(
                        value: TemperatureUnit.fahrenheit,
                        label: Text('Fahrenheit (°F)'),
                        icon: Icon(Icons.device_thermostat),
                      ),
                    ],
                    selected: {provider.temperatureUnit},
                    style: ButtonStyle(
                      foregroundColor: WidgetStateProperty.resolveWith((
                        states,
                      ) {
                        if (states.contains(WidgetState.selected)) {
                          return const Color(0xFF032D60);
                        }
                        return Colors.white;
                      }),
                      backgroundColor: WidgetStateProperty.resolveWith((
                        states,
                      ) {
                        if (states.contains(WidgetState.selected)) {
                          return const Color(0xFFA3F6FF);
                        }
                        return Colors.white.withValues(alpha: 0.1);
                      }),
                      side: WidgetStatePropertyAll(
                        BorderSide(color: Colors.white.withValues(alpha: 0.25)),
                      ),
                    ),
                    onSelectionChanged: (selectedSet) {
                      HapticFeedback.selectionClick();
                      provider.setTemperatureUnit(selectedSet.first);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
