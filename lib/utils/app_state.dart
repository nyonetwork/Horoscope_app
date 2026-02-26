import 'package:flutter/material.dart';
import 'package:horoscope_app/utils/local_storage.dart';
import 'package:horoscope_app/utils/zodiac_utils.dart';

class AppState extends ChangeNotifier {
  DateTime? _birthdate;
  String _selectedZodiac = 'Aries';
  bool _isPremium = false;
  bool _isReady = false;

  DateTime? get birthdate => _birthdate;
  String get selectedZodiac => _selectedZodiac;
  bool get isPremium => _isPremium;
  bool get isReady => _isReady;
  bool get needsOnboarding => _birthdate == null;

  Future<void> initialize() async {
    _birthdate = await LocalStorage.getBirthdate();
    _selectedZodiac = await LocalStorage.getSelectedZodiac() ??
        (_birthdate == null ? 'Aries' : ZodiacUtils.getZodiac(_birthdate!));
    _isPremium = await LocalStorage.getPremiumStatus();
    _isReady = true;
    notifyListeners();
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

  Future<void> setPremiumStatus(bool value) async {
    _isPremium = value;
    await LocalStorage.savePremiumStatus(value);
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
