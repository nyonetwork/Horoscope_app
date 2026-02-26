import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const String birthdateKey = 'birthdate';
  static const String zodiacKey = 'selected_zodiac';
  static const String premiumKey = 'is_premium';

  static Future<void> saveBirthdate(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(birthdateKey, date.toIso8601String());
  }

  static Future<DateTime?> getBirthdate() async {
    final prefs = await SharedPreferences.getInstance();
    final dateString = prefs.getString(birthdateKey);
    if (dateString == null) return null;
    return DateTime.parse(dateString);
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
}
