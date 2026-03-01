import 'package:flutter_test/flutter_test.dart';
import 'package:horoscope_app/utils/zodiac_utils.dart';

void main() {
  group('ZodiacUtils.getZodiac', () {
    test('returns Aries on Aries boundary start', () {
      expect(ZodiacUtils.getZodiac(DateTime(2026, 3, 21)), 'Aries');
    });

    test('returns Taurus on Taurus boundary start', () {
      expect(ZodiacUtils.getZodiac(DateTime(2026, 4, 20)), 'Taurus');
    });

    test('returns Capricorn near year transition', () {
      expect(ZodiacUtils.getZodiac(DateTime(2026, 1, 10)), 'Capricorn');
    });

    test('returns Aquarius at Aquarius boundary', () {
      expect(ZodiacUtils.getZodiac(DateTime(2026, 1, 20)), 'Aquarius');
    });
  });
}
