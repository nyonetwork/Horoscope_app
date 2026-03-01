import 'package:horoscope_app/data/horoscope_api_client.dart';
import 'package:horoscope_app/data/horoscope_database_2026.dart';
import 'package:horoscope_app/data/horoscope_data.dart';
import 'package:horoscope_app/utils/local_storage.dart';

class HoroscopeRepository {
  static Future<Map<String, String>> fetchDaily(
    String sign, {
    DateTime? date,
  }) async {
    final targetDate = date ?? DateTime.now();
    final local2026 = HoroscopeDatabase2026.getDailyBundle(
      sign: sign,
      date: targetDate,
    );
    if (local2026 != null) {
      await LocalStorage.saveHoroscopeCache(sign, local2026);
      return local2026;
    }

    final remote = await HoroscopeApiClient.fetchDaily(sign: sign);
    if (remote != null) {
      await LocalStorage.saveHoroscopeCache(sign, remote);
      return remote;
    }

    final data = HoroscopeData.daily[sign];
    if (data == null) {
      throw StateError('No horoscope data found for $sign');
    }

    await LocalStorage.saveHoroscopeCache(sign, data);
    return data;
  }

  static Future<Map<String, String>?> getCachedDaily(String sign) async {
    return LocalStorage.getHoroscopeCache(sign);
  }
}
