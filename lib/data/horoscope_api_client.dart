import 'dart:convert';

import 'package:http/http.dart' as http;

class HoroscopeApiClient {
  static const String _baseUrl = String.fromEnvironment(
    'HOROSCOPE_API_BASE_URL',
  );
  static const String _apiKey = String.fromEnvironment('HOROSCOPE_API_KEY');

  static bool get isConfigured => _baseUrl.trim().isNotEmpty;

  static Future<Map<String, String>?> fetchDaily({
    required String sign,
    DateTime? date,
  }) async {
    if (!isConfigured) return null;

    final targetDate = date ?? DateTime.now();
    final dateLabel =
        '${targetDate.year}-${targetDate.month.toString().padLeft(2, '0')}-${targetDate.day.toString().padLeft(2, '0')}';
    final uri = Uri.parse(
      '$_baseUrl/daily',
    ).replace(queryParameters: {'sign': sign, 'date': dateLabel});

    final headers = <String, String>{'Accept': 'application/json'};
    if (_apiKey.trim().isNotEmpty) {
      headers['Authorization'] = 'Bearer $_apiKey';
    }

    final response = await http
        .get(uri, headers: headers)
        .timeout(const Duration(seconds: 8));
    if (response.statusCode != 200) return null;

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) return null;
    final daily = decoded['daily'];
    if (daily is! Map<String, dynamic>) return null;

    final yesterday = daily['yesterday'];
    final today = daily['today'];
    final tomorrow = daily['tomorrow'];
    if (yesterday is! String || today is! String || tomorrow is! String) {
      return null;
    }

    return {'yesterday': yesterday, 'today': today, 'tomorrow': tomorrow};
  }
}
