import 'package:flutter/material.dart';
import 'package:horoscope_app/screens/chat_screen.dart';
import 'package:horoscope_app/screens/compatibility_screen.dart';
import 'package:horoscope_app/screens/home_screen.dart';
import 'package:horoscope_app/screens/premium_screen.dart';
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

  void _openPremium() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const PremiumScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final screens = [
      HomeScreen(onOpenSettings: _openSettings, onOpenPremium: _openPremium),
      CompatibilityScreen(
        onOpenSettings: _openSettings,
        onOpenPremium: _openPremium,
      ),
      const ChatScreen(),
    ];

    return Scaffold(
      extendBody: true,
      body: CosmicBackground(
        reduceMotion: appState.reduceMotion,
        child: screens[_selectedIndex],
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(20, 0, 20, 14),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0x663B4B83)),
            color: const Color(0xAA141B36),
            boxShadow: const [
              BoxShadow(
                color: Color(0x33000000),
                blurRadius: 16,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: (index) => setState(() => _selectedIndex = index),
              type: BottomNavigationBarType.fixed,
              showSelectedLabels: true,
              showUnselectedLabels: false,
              selectedFontSize: 12,
              unselectedFontSize: 12,
              elevation: 0,
              backgroundColor: Colors.transparent,
              selectedItemColor: const Color(0xFFEAF0FF),
              unselectedItemColor: const Color(0xFFB9C4E7),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_rounded),
                  activeIcon: _SelectedNavIcon(icon: Icons.home_rounded),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.favorite_rounded),
                  activeIcon: _SelectedNavIcon(icon: Icons.favorite_rounded),
                  label: 'Compatibility',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.chat_bubble_rounded),
                  activeIcon: _SelectedNavIcon(icon: Icons.chat_bubble_rounded),
                  label: 'Chat',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SelectedNavIcon extends StatelessWidget {
  const _SelectedNavIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFF3B4B83).withOpacity(0.45),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon),
    );
  }
}
