import 'package:flutter/material.dart';
import 'package:horoscope_app/utils/local_storage.dart';
import 'package:horoscope_app/utils/zodiac_utils.dart';

class AppState extends ChangeNotifier {
  DateTime? _birthdate;
  String _selectedZodiac = 'Aries';
  bool _isPremium = false;
  bool _reduceMotion = false;
  bool _isReady = false;
  String? _initError;
  int _streakCount = 0;
  DateTime? _lastCheckInDate;

  DateTime? get birthdate => _birthdate;
  String get selectedZodiac => _selectedZodiac;
  bool get isPremium => _isPremium;
  bool get reduceMotion => _reduceMotion;
  bool get isReady => _isReady;
  String? get initError => _initError;
  int get streakCount => _streakCount;
  bool get needsOnboarding => _birthdate == null;
  bool get didCheckInToday {
    if (_lastCheckInDate == null) return false;
    final now = DateTime.now();
    return _lastCheckInDate!.year == now.year &&
        _lastCheckInDate!.month == now.month &&
        _lastCheckInDate!.day == now.day;
  }

  Future<void> initialize() async {
    _isReady = false;
    _initError = null;
    notifyListeners();
    try {
      _birthdate = await LocalStorage.getBirthdate();
    } catch (_) {
      _birthdate = null;
    }
    try {
      final savedSign = await LocalStorage.getSelectedZodiac();
      final fallbackSign = _birthdate == null
          ? 'Aries'
          : ZodiacUtils.getZodiac(_birthdate!);
      _selectedZodiac = ZodiacUtils.allSigns.contains(savedSign)
          ? savedSign!
          : fallbackSign;
    } catch (_) {
      _selectedZodiac = _birthdate == null
          ? 'Aries'
          : ZodiacUtils.getZodiac(_birthdate!);
    }
    try {
      _isPremium = await LocalStorage.getPremiumStatus();
    } catch (_) {
      _isPremium = false;
    }
    try {
      _reduceMotion = await LocalStorage.getReducedMotion();
    } catch (_) {
      _reduceMotion = false;
    }
    try {
      _streakCount = await LocalStorage.getStreakCount();
      _lastCheckInDate = await LocalStorage.getLastCheckInDate();
    } catch (_) {
      _streakCount = 0;
      _lastCheckInDate = null;
    }
    _isReady = true;
    notifyListeners();
  }

  Future<void> retryInitialize() async {
    await initialize();
  }

  Future<void> setBirthdate(DateTime date) async {
    _birthdate = date;
    _selectedZodiac = ZodiacUtils.getZodiac(date);
    await LocalStorage.saveBirthdate(date);
    await LocalStorage.saveSelectedZodiac(_selectedZodiac);
    notifyListeners();
  }

  Future<void> setSelectedZodiac(String zodiac) async {
    _selectedZodiac = zodiac;
    await LocalStorage.saveSelectedZodiac(zodiac);
    notifyListeners();
  }

  Future<void> markDailyCheckIn() async {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    if (_lastCheckInDate != null) {
      final previous = DateTime(
        _lastCheckInDate!.year,
        _lastCheckInDate!.month,
        _lastCheckInDate!.day,
      );
      if (previous == todayDate) return;

      if (todayDate.difference(previous).inDays == 1) {
        _streakCount += 1;
      } else {
        _streakCount = 1;
      }
    } else {
      _streakCount = 1;
    }

    _lastCheckInDate = todayDate;
    await LocalStorage.saveStreakCount(_streakCount);
    await LocalStorage.saveLastCheckInDate(todayDate);
    notifyListeners();
  }

  Future<void> setPremiumStatus(bool value) async {
    _isPremium = value;
    await LocalStorage.savePremiumStatus(value);
    notifyListeners();
  }

  Future<void> setReduceMotion(bool value) async {
    _reduceMotion = value;
    await LocalStorage.saveReducedMotion(value);
    notifyListeners();
  }
}

class AppStateScope extends InheritedNotifier<AppState> {
  const AppStateScope({
    super.key,
    required AppState notifier,
    required super.child,
  }) : super(notifier: notifier);

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppStateScope>();
    assert(scope != null, 'AppStateScope not found in widget tree');
    return scope!.notifier!;
  }
}
