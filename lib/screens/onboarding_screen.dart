import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:horoscope_app/screens/main_navigation.dart';
import 'package:horoscope_app/utils/app_state.dart';
import 'package:horoscope_app/utils/zodiac_utils.dart';
import 'package:horoscope_app/widgets/cosmic_background.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  DateTime _selectedDate = DateTime(2000, 1, 1);
  late String _selectedSign;
  late final ValueNotifier<String> _previewSign;
  bool _isSaving = false;
  bool _showReveal = false;
  late final AnimationController _revealController;

  @override
  void initState() {
    super.initState();
    _selectedSign = ZodiacUtils.getZodiac(_selectedDate);
    _previewSign = ValueNotifier<String>(_selectedSign);
    _revealController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 980),
    );
  }

  @override
  void dispose() {
    _previewSign.dispose();
    _revealController.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);
    try {
      final appState = AppStateScope.of(context);

      if (!appState.reduceMotion) {
        await HapticFeedback.mediumImpact();
        if (mounted) setState(() => _showReveal = true);
        await _revealController.forward(from: 0);
      }

      await appState.setBirthdate(_selectedDate);

      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainNavigation()),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
          _showReveal = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    return Scaffold(
      body: Stack(
        children: [
          CosmicBackground(
            reduceMotion: appState.reduceMotion,
            child: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
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
                              color: const Color(
                                0xFF0D1020,
                              ).withValues(alpha: 0.86),
                              border: Border.all(
                                color: const Color(0xFF2D3E87),
                              ),
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
                                ValueListenableBuilder<String>(
                                  valueListenable: _previewSign,
                                  builder: (context, sign, _) {
                                    return AnimatedSwitcher(
                                      duration: const Duration(
                                        milliseconds: 230,
                                      ),
                                      child: Container(
                                        key: ValueKey(sign),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF111730),
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                          border: Border.all(
                                            color: const Color(0xFF2C3E7A),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Text(
                                              ZodiacUtils.symbol(sign),
                                              style: const TextStyle(
                                                fontSize: 22,
                                                height: 1,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              'Your sign: ${ZodiacUtils.displayName(sign)}',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFFE4EBFF),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 10),
                                MediaQuery(
                                  data: MediaQuery.of(context).copyWith(
                                    textScaler: const TextScaler.linear(1.0),
                                  ),
                                  child: SizedBox(
                                    height: 220,
                                    child: CupertinoDatePicker(
                                      mode: CupertinoDatePickerMode.date,
                                      initialDateTime: _selectedDate,
                                      minimumDate: DateTime(1950),
                                      maximumDate: DateTime.now(),
                                      onDateTimeChanged: (date) {
                                        _selectedDate = date;
                                        final nextSign = ZodiacUtils.getZodiac(
                                          date,
                                        );
                                        if (nextSign != _selectedSign) {
                                          _selectedSign = nextSign;
                                          _previewSign.value = nextSign;
                                          HapticFeedback.selectionClick();
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isSaving ? null : _continue,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF6F7BFF),
                                foregroundColor: Colors.white,
                                minimumSize: const Size.fromHeight(52),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: _isSaving
                                  ? const SizedBox(
                                      height: 18,
                                      width: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text(
                                      'Continue',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          IgnorePointer(
            ignoring: !_showReveal,
            child: AnimatedOpacity(
              opacity: _showReveal ? 1 : 0,
              duration: const Duration(milliseconds: 220),
              child: ColoredBox(
                color: const Color(0xA0060A18),
                child: Center(
                  child: _SignReveal(
                    sign: _selectedSign,
                    controller: _revealController,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SignReveal extends StatelessWidget {
  final String sign;
  final Animation<double> controller;

  const _SignReveal({required this.sign, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final eased = Curves.easeOutCubic.transform(controller.value);
        final glowOpacity = (0.2 + eased * 0.8).clamp(0.0, 1.0);
        return SizedBox(
          width: 280,
          height: 280,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: const Size(280, 280),
                painter: _SmokeAuraPainter(progress: controller.value),
              ),
              Container(
                width: 188 + (eased * 34),
                height: 188 + (eased * 34),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.white.withValues(alpha: glowOpacity * 0.85),
                      const Color(
                        0xFF8FA7FF,
                      ).withValues(alpha: glowOpacity * 0.45),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              Transform.scale(
                scale: 0.74 + (eased * 0.30),
                child: Opacity(
                  opacity: eased,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        ZodiacUtils.symbol(sign),
                        style: const TextStyle(
                          fontSize: 88,
                          height: 1,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${ZodiacUtils.displayName(sign)} Chosen',
                        style: const TextStyle(
                          color: Color(0xFFE8EEFF),
                          fontSize: 21,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SmokeAuraPainter extends CustomPainter {
  final double progress;

  const _SmokeAuraPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final pulse = math.sin(progress * math.pi * 2) * 0.5 + 0.5;

    for (var i = 0; i < 14; i++) {
      final t = (i / 14) + progress * 0.42;
      final angle = t * math.pi * 2;
      final radius = 70 + math.sin((progress + i) * 2.3) * 26;
      final x = center.dx + math.cos(angle) * radius;
      final y = center.dy + math.sin(angle) * (radius * 0.72);
      final smokeSize = 22 + (i % 4) * 8 + (pulse * 7);
      final opacity = (0.11 + (pulse * 0.10)).clamp(0.0, 0.22);

      final paint = Paint()
        ..color = const Color(0xFFA8B7FF).withValues(alpha: opacity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18);

      canvas.drawCircle(Offset(x, y), smokeSize, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SmokeAuraPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
