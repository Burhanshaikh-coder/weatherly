import 'package:flutter/material.dart';
import 'package:sky_pulse/widgets/app_drawer.dart';
import 'package:sky_pulse/widgets/glass_card.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          title: const Text('About'),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF032D60), Color(0xFF005E8A), Color(0xFF0BA37F)],
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Smart Weather',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text('Version: 1.0.0'),
                  SizedBox(height: 12),
                  Text(
                    'Smart Weather is a premium weather app with modern glassmorphism UI, city search, saved cities, and a 7-day forecast with temperature trends.',
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
