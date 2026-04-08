import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sky_pulse/providers/weather_provider.dart';
import 'package:sky_pulse/widgets/app_drawer.dart';

class SavedCitiesScreen extends StatelessWidget {
  const SavedCitiesScreen({super.key});

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
          title: const Text('Saved Cities'),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF032D60), Color(0xFF005E8A), Color(0xFF0BA37F)],
            ),
          ),
          child:
              provider.savedCities.isEmpty
                  ? const Center(
                    child: Text(
                      'No saved cities yet',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                  : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemBuilder: (_, index) {
                      final city = provider.savedCities[index];
                      return _HoldToDeleteTile(
                        city: city,
                        onOpen: () async {
                          await provider.fetchWeather(city);
                          if (!context.mounted) return;
                          Navigator.pushReplacementNamed(context, '/');
                        },
                        onDelete: () async {
                          final deleted = await provider.deleteSavedCity(city);
                          if (!context.mounted || !deleted) return;
                          HapticFeedback.selectionClick();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              backgroundColor: const Color(
                                0xFF0B2A4A,
                              ).withValues(alpha: 0.96),
                              content: const Text('City deleted'),
                            ),
                          );
                        },
                      );
                    },
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemCount: provider.savedCities.length,
                  ),
        ),
      ),
    );
  }
}

class _HoldToDeleteTile extends StatefulWidget {
  const _HoldToDeleteTile({
    required this.city,
    required this.onOpen,
    required this.onDelete,
  });

  final String city;
  final Future<void> Function() onOpen;
  final Future<void> Function() onDelete;

  @override
  State<_HoldToDeleteTile> createState() => _HoldToDeleteTileState();
}

class _HoldToDeleteTileState extends State<_HoldToDeleteTile> {
  Timer? _deleteTimer;
  bool _didTriggerDelete = false;

  void _startDeleteHold() {
    _didTriggerDelete = false;
    _deleteTimer?.cancel();
    _deleteTimer = Timer(const Duration(seconds: 1), () async {
      _didTriggerDelete = true;
      if (!mounted) return;
      final shouldDelete = await showDialog<bool>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text('Delete City'),
            content: const Text('Are you sure you want to delete?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                child: const Text('Delete'),
              ),
            ],
          );
        },
      );
      if (shouldDelete == true) {
        await widget.onDelete();
      }
    });
  }

  void _cancelDeleteHold() {
    _deleteTimer?.cancel();
  }

  @override
  void dispose() {
    _deleteTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => _startDeleteHold(),
      onPointerUp: (_) => _cancelDeleteHold(),
      onPointerCancel: (_) => _cancelDeleteHold(),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        tileColor: Colors.white.withValues(alpha: 0.14),
        title: Text(widget.city, style: const TextStyle(color: Colors.white)),
        subtitle: const Text(
          'Hold to delete',
          style: TextStyle(color: Colors.white70, fontSize: 12),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.white),
        onTap: () async {
          if (_didTriggerDelete) return;
          await widget.onOpen();
        },
      ),
    );
  }
}
