import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horoscope_app/screens/main_navigation.dart';
import 'package:horoscope_app/utils/app_state.dart';
import 'package:horoscope_app/widgets/cosmic_background.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  DateTime _selectedDate = DateTime(2000, 1, 1);

  Future<void> _continue() async {
    final appState = AppStateScope.of(context);
    await appState.setBirthdate(_selectedDate);

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainNavigation()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                const Text(
                  'Daily Horoscope',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Enter your birth date to detect your zodiac sign automatically.',
                  style: TextStyle(color: Color(0xFFBAC2E6)),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D1020).withValues(alpha: 0.86),
                    border: Border.all(color: const Color(0xFF2D3E87)),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'BIRTH DATE',
                        style: TextStyle(
                          fontSize: 13,
                          letterSpacing: 1.1,
                          color: Color(0xFF9EA8CD),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 220,
                        child: CupertinoDatePicker(
                          mode: CupertinoDatePickerMode.date,
                          initialDateTime: _selectedDate,
                          minimumDate: DateTime(1950),
                          maximumDate: DateTime.now(),
                          onDateTimeChanged: (date) {
                            setState(() => _selectedDate = date);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _continue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6F7BFF),
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
