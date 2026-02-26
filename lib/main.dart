import 'package:flutter/material.dart';
import 'package:horoscope_app/screens/main_navigation.dart';
import 'package:horoscope_app/screens/onboarding_screen.dart';
import 'package:horoscope_app/utils/app_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppState _appState = AppState();

  @override
  void initState() {
    super.initState();
    _appState.initialize();
  }

  @override
  void dispose() {
    _appState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppStateScope(
      notifier: _appState,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF06070D),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF7C7BFF),
            brightness: Brightness.dark,
          ),
          cardColor: const Color(0xFF111321),
          textTheme: const TextTheme(
            headlineMedium: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
            titleLarge: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
            bodyMedium: TextStyle(
              fontSize: 15,
              height: 1.4,
              color: Color(0xFFD5DAF0),
            ),
          ),
        ),
        home: AnimatedBuilder(
          animation: _appState,
          builder: (context, child) {
            if (!_appState.isReady) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            if (_appState.needsOnboarding) {
              return const OnboardingScreen();
            }
            return const MainNavigation();
          },
        ),
      ),
    );
  }
}
