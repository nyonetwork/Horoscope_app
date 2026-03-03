import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:horoscope_app/screens/compatibility_screen.dart';
import 'package:horoscope_app/screens/home_screen.dart';
import 'package:horoscope_app/utils/app_state.dart';

void main() {
  testWidgets('HomeScreen builds without throwing', (tester) async {
    final appState = AppState();
    await tester.pumpWidget(
      AppStateScope(
        notifier: appState,
        child: const MaterialApp(
          home: Scaffold(
            body: HomeScreen(
              onOpenSettings: _noop,
              onOpenPremium: _noop,
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('CompatibilityScreen builds without throwing', (tester) async {
    final appState = AppState();
    await tester.pumpWidget(
      AppStateScope(
        notifier: appState,
        child: const MaterialApp(
          home: Scaffold(
            body: CompatibilityScreen(
              onOpenSettings: _noop,
              onOpenPremium: _noop,
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    expect(find.byType(CompatibilityScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

void _noop() {}
