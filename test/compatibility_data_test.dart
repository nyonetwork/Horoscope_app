import 'package:flutter_test/flutter_test.dart';
import 'package:horoscope_app/data/compatibility_data.dart';

void main() {
  group('CompatibilityData.calculateScore', () {
    test('returns high score for same sign', () {
      expect(CompatibilityData.calculateScore('Aries', 'Aries'), 91);
    });

    test('is symmetric for pair order', () {
      final ab = CompatibilityData.calculateScore('Aries', 'Leo');
      final ba = CompatibilityData.calculateScore('Leo', 'Aries');
      expect(ab, ba);
    });

    test('friendly elemental pair scores above challenging pair', () {
      final friendly = CompatibilityData.calculateScore('Aries', 'Gemini');
      final challenging = CompatibilityData.calculateScore('Aries', 'Cancer');
      expect(friendly, greaterThan(challenging));
    });

    test('score stays in expected bounds', () {
      final score = CompatibilityData.calculateScore('Virgo', 'Aquarius');
      expect(score, inInclusiveRange(35, 98));
    });

    test('birth day and year can influence score for same sign pair', () {
      final closeBirthDates = CompatibilityData.calculateScore(
        'Aries',
        'Leo',
        firstBirthdate: DateTime(1998, 4, 10),
        secondBirthdate: DateTime(1999, 4, 12),
      );
      final distantBirthDates = CompatibilityData.calculateScore(
        'Aries',
        'Leo',
        firstBirthdate: DateTime(1980, 4, 1),
        secondBirthdate: DateTime(2005, 10, 28),
      );
      expect(closeBirthDates, isNot(equals(distantBirthDates)));
    });

    test('date-aware score is symmetric by person order', () {
      final a = CompatibilityData.calculateScore(
        'Cancer',
        'Pisces',
        firstBirthdate: DateTime(1996, 7, 2),
        secondBirthdate: DateTime(1998, 3, 1),
      );
      final b = CompatibilityData.calculateScore(
        'Pisces',
        'Cancer',
        firstBirthdate: DateTime(1998, 3, 1),
        secondBirthdate: DateTime(1996, 7, 2),
      );
      expect(a, b);
    });
  });
}
