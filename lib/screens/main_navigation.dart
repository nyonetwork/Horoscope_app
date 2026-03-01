import 'package:flutter/material.dart';
import 'package:horoscope_app/screens/compatibility_screen.dart';
import 'package:horoscope_app/screens/home_screen.dart';
import 'package:horoscope_app/screens/settings_screen.dart';
import 'package:horoscope_app/utils/app_state.dart';
import 'package:horoscope_app/widgets/cosmic_background.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  void _openSettings() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const SettingsScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final screens = [
      HomeScreen(onOpenSettings: _openSettings),
      const CompatibilityScreen(),
    ];

    return Scaffold(
      body: CosmicBackground(
        reduceMotion: appState.reduceMotion,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 260),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          child: KeyedSubtree(
            key: ValueKey(_selectedIndex),
            child: screens[_selectedIndex],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xE80E142A),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFF304172)),
          ),
          child: Row(
            children: [
              Expanded(
                child: _tabItem(
                  icon: Icons.home_rounded,
                  index: 0,
                  label: 'Home',
                ),
              ),
              Expanded(
                child: _tabItem(
                  icon: Icons.favorite_rounded,
                  index: 1,
                  label: 'Match',
                ),
              ),
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
    final textColor = isActive
        ? const Color(0xFFEAF0FF)
        : const Color(0xFFB9C4E7);
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => setState(() => _selectedIndex = index),
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        offset: isActive ? Offset.zero : const Offset(0, 0.08),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF1B2649) : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: isActive ? 21 : 20, color: textColor),
              const SizedBox(height: 2),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isActive ? FontWeight.w500 : FontWeight.w400,
                  color: textColor,
                ),
                child: Text(label),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
