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
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6F7BFF),
              foregroundColor: Colors.white,
              disabledBackgroundColor: const Color(0xFF40455E),
              disabledForegroundColor: const Color(0xFFC0C7E8),
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFFE6EBFF),
              side: const BorderSide(color: Color(0xFF3A4775)),
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          textTheme: const TextTheme(
            headlineMedium: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
            titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            bodyMedium: TextStyle(
              fontSize: 15,
              height: 1.55,
              color: Color(0xFFE0E7FF),
            ),
          ),
        ),
        home: AnimatedBuilder(
          animation: _appState,
          builder: (context, child) {
            if (!_appState.isReady) {
              if (_appState.initError != null) {
                return Scaffold(
                  body: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.cloud_off_rounded,
                            size: 40,
                            color: Color(0xFFE4E9FF),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Something went wrong',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _appState.initError!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Color(0xFFD7DFFD)),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _appState.retryInitialize,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
              return const Scaffold(
                body: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 12),
                      Text(
                        'Loading your cosmic profile...',
                        style: TextStyle(color: Color(0xFFD9E1FF)),
                      ),
                    ],
                  ),
                ),
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
