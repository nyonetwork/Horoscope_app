import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:horoscope_app/screens/home_screen.dart';
import 'package:horoscope_app/screens/main_navigation.dart';
import 'package:horoscope_app/utils/app_state.dart';

void main() {
  testWidgets('MainNavigation renders Home and Compatibility tabs', (tester) async {
    final appState = AppState();
    await tester.pumpWidget(
      AppStateScope(
        notifier: appState,
        child: const MaterialApp(
          home: TickerMode(enabled: false, child: MainNavigation()),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(MainNavigation), findsOneWidget);
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.byIcon(Icons.home_rounded), findsOneWidget);
    expect(find.byIcon(Icons.favorite_rounded), findsOneWidget);

    await tester.tap(find.byIcon(Icons.favorite_rounded));
    await tester.pump();

    expect(tester.takeException(), isNull);
  });
}
