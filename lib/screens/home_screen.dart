import 'package:flutter/material.dart';
import 'package:horoscope_app/data/horoscope_data.dart';
import 'package:horoscope_app/utils/app_state.dart';
import 'package:horoscope_app/utils/zodiac_utils.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onOpenProfile;

  const HomeScreen({
    super.key,
    required this.onOpenProfile,
  });

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final sign = appState.selectedZodiac;
    final dailyData = HoroscopeData.daily[sign] ?? HoroscopeData.daily['Aries']!;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 120),
        children: [
          _symbolHeader(sign: sign),
          const SizedBox(height: 24),
          _forecastCard(
            context,
            title: 'Yesterday',
            content: dailyData['yesterday']!,
            icon: Icons.history_toggle_off_rounded,
            accent: const Color(0xFFBBD1FF),
          ),
          const SizedBox(height: 14),
          _forecastCard(
            context,
            title: 'Today',
            content: dailyData['today']!,
            icon: Icons.wb_sunny_rounded,
            accent: const Color(0xFFFFD6A5),
          ),
          const SizedBox(height: 14),
          if (appState.isPremium)
            _forecastCard(
              context,
              title: 'Tomorrow',
              content: dailyData['tomorrow']!,
              icon: Icons.auto_awesome_rounded,
              accent: const Color(0xFFE2C7FF),
            )
          else
            _lockedTomorrowCard(context),
        ],
      ),
    );
  }

  Widget _symbolHeader({required String sign}) {
    return Center(
      child: Column(
        children: [
          Container(
            width: 124,
            height: 124,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF8CB4FF), Color(0xFF6B72FF), Color(0xFF412E77)],
              ),
              border: Border.all(color: Colors.white.withValues(alpha: 0.30), width: 1.2),
              boxShadow: const [
                BoxShadow(color: Color(0x802E4DAD), blurRadius: 38, spreadRadius: 4),
                BoxShadow(color: Color(0x502D1E52), blurRadius: 14),
              ],
            ),
            child: Text(
              ZodiacUtils.symbol(sign),
              style: const TextStyle(fontSize: 62, color: Colors.white, height: 1),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Your cosmic sign',
            style: TextStyle(
              color: Color(0xFFD2DCF9),
              fontSize: 14,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _forecastCard(
    BuildContext context, {
    required String title,
    required String content,
    required IconData icon,
    required Color accent,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xEE131B38),
            const Color(0xEE0D1430),
            const Color(0xEE090F25),
          ],
        ),
        border: Border.all(color: accent.withValues(alpha: 0.35), width: 1.1),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.18),
            blurRadius: 20,
            spreadRadius: 1,
            offset: const Offset(0, 5),
          ),
          const BoxShadow(
            color: Color(0x66060A18),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 20, color: accent),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(content, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }

  Widget _lockedTomorrowCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xEE281C36), Color(0xEE1B1629), Color(0xEE130F21)],
        ),
        border: Border.all(color: const Color(0x88FFC28F), width: 1.1),
        boxShadow: const [
          BoxShadow(color: Color(0x44FFB067), blurRadius: 18, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.lock_rounded, color: Color(0xFFFFD9A4)),
              SizedBox(width: 8),
              Text(
                'Tomorrow (Premium)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Tomorrow\'s reading unlocks with Premium access.',
            style: TextStyle(color: Color(0xFFF4DAE8)),
          ),
          const SizedBox(height: 14),
          TextButton.icon(
            onPressed: onOpenProfile,
            icon: const Icon(Icons.stars_rounded),
            label: const Text('Go to Profile to activate Premium'),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFFFD9A4),
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}
