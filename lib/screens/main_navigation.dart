import 'package:flutter/material.dart';
import 'package:horoscope_app/screens/compatibility_screen.dart';
import 'package:horoscope_app/screens/home_screen.dart';
import 'package:horoscope_app/screens/settings_screen.dart';
import 'package:horoscope_app/widgets/cosmic_background.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  void _openProfileTab() {
    setState(() => _selectedIndex = 2);
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(onOpenProfile: _openProfileTab),
      const CompatibilityScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      body: CosmicBackground(child: screens[_selectedIndex]),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.92),
            borderRadius: BorderRadius.circular(28),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _tabItem(icon: Icons.home_rounded, index: 0, label: 'Home'),
              _tabItem(icon: Icons.favorite_rounded, index: 1, label: 'Match'),
              _tabItem(icon: Icons.person_rounded, index: 2, label: 'Profile'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tabItem({
    required IconData icon,
    required int index,
    required String label,
  }) {
    final isActive = _selectedIndex == index;
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () => setState(() => _selectedIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF0E1020) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 22,
              color: isActive ? Colors.white : const Color(0xFF202437),
            ),
            if (isActive) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
