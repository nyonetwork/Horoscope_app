import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const String birthdateKey = 'birthdate';
  static const String zodiacKey = 'selected_zodiac';
  static const String premiumKey = 'is_premium';
  static const String reducedMotionKey = 'reduced_motion';
  static const String streakCountKey = 'streak_count';
  static const String streakDateKey = 'streak_last_date';

  static Future<void> saveBirthdate(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(birthdateKey, date.toIso8601String());
  }

  static Future<DateTime?> getBirthdate() async {
    final prefs = await SharedPreferences.getInstance();
    final dateString = prefs.getString(birthdateKey);
    if (dateString == null) return null;
    try {
      return DateTime.parse(dateString);
    } on FormatException {
      return null;
    }
  }

  static Future<void> saveSelectedZodiac(String zodiac) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(zodiacKey, zodiac);
  }

  static Future<String?> getSelectedZodiac() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(zodiacKey);
  }

  static Future<void> savePremiumStatus(bool isPremium) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(premiumKey, isPremium);
  }

  static Future<bool> getPremiumStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(premiumKey) ?? false;
  }

  static Future<void> saveReducedMotion(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(reducedMotionKey, value);
  }

  static Future<bool> getReducedMotion() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(reducedMotionKey) ?? false;
  }

  static Future<void> saveStreakCount(int count) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(streakCountKey, count);
  }

  static Future<int> getStreakCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(streakCountKey) ?? 0;
  }

  static Future<void> saveLastCheckInDate(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      streakDateKey,
      DateTime(date.year, date.month, date.day).toIso8601String(),
    );
  }

  static Future<DateTime?> getLastCheckInDate() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(streakDateKey);
    if (value == null) return null;
    try {
      return DateTime.parse(value);
    } on FormatException {
      return null;
    }
  }
}
