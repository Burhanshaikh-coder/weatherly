import 'package:flutter/material.dart';
import 'package:sky_pulse/utils/constants.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF0B2A4A),
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
             Container(
              height: 100, // 👈 exact height control
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              alignment: Alignment.bottomLeft,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0E3B89), Color(0xFF0B9AA8)],
                ),
              ),
              child: const Text(
                AppConstants.appName,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            _DrawerItem(
              icon: Icons.home_rounded,
              label: 'Home',
              onTap: () => Navigator.pushReplacementNamed(context, '/'),
            ),
            _DrawerItem(
              icon: Icons.favorite_rounded,
              label: 'Saved Cities',
              onTap: () => Navigator.pushReplacementNamed(context, '/saved'),
            ),
            _DrawerItem(
              icon: Icons.settings_rounded,
              label: 'Settings',
              onTap: () => Navigator.pushReplacementNamed(context, '/settings'),
            ),
            _DrawerItem(
              icon: Icons.info_rounded,
              label: 'About',
              onTap: () => Navigator.pushReplacementNamed(context, '/about'),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(label, style: const TextStyle(color: Colors.white)),
      onTap: onTap,
    );
  }
}
