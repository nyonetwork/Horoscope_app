import 'package:flutter_test/flutter_test.dart';
import 'package:horoscope_app/main.dart';
import 'package:horoscope_app/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('App shows HomeScreen for onboarded user', (tester) async {
    SharedPreferences.setMockInitialValues({
      'birthdate': '2000-01-01T00:00:00.000',
      'selected_zodiac': 'Aries',
    });

    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(milliseconds: 1200));

    expect(find.byType(HomeScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
