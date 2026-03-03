import 'package:flutter/material.dart';
import 'package:horoscope_app/screens/main_navigation.dart';
import 'package:horoscope_app/screens/onboarding_screen.dart';
import 'package:horoscope_app/utils/app_state.dart';
import 'package:horoscope_app/theme/app_colors.dart';

void main() {
  assert(() {
    ErrorWidget.builder = (FlutterErrorDetails details) {
      return Material(
        color: const Color(0xCC2A0012),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Text(
              details.exceptionAsString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        ),
      );
    };
    return true;
  }());
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
          scaffoldBackgroundColor: AppColors.scaffoldBackground,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.seed,
            brightness: Brightness.dark,
          ),
          cardColor: AppColors.card,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.buttonPrimary,
              foregroundColor: Colors.white,
              disabledBackgroundColor: AppColors.buttonDisabled,
              disabledForegroundColor: AppColors.buttonDisabledForeground,
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
              foregroundColor: AppColors.outlineForeground,
              side: const BorderSide(color: AppColors.outlineBorder),
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
              color: AppColors.textBody,
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
                            'Алдаа гарлаа',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _appState.initError!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppColors.textErrorBody,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _appState.retryInitialize,
                            child: const Text('Дахин оролдох'),
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
                        'Таны профайлыг ачаалж байна...',
                        style: TextStyle(color: AppColors.textLoadingBody),
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
