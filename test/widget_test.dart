import 'package:flutter_test/flutter_test.dart';
import 'package:horoscope_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Onboarding renders for new users', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.text('Өд�?ийн з�f�?�.ай'), findsOneWidget);
    expect(find.text('Ү�?гэлжлүүлэ�.'), findsOneWidget);
  });
}

