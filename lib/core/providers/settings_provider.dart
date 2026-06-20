import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../constants/app_constants.dart';

class SettingsProvider extends ChangeNotifier {
  late Box _box;

  SettingsProvider() {
    _box = Hive.box(AppConstants.settingsBox);
  }

  ThemeMode get themeMode {
    final val = _box.get(AppConstants.keyThemeMode, defaultValue: 'dark');
    switch (val) {
      case 'light': return ThemeMode.light;
      case 'system': return ThemeMode.system;
      default: return ThemeMode.dark;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final val = mode == ThemeMode.light
        ? 'light'
        : mode == ThemeMode.system
            ? 'system'
            : 'dark';
    await _box.put(AppConstants.keyThemeMode, val);
    notifyListeners();
  }

  Locale get locale {
    final lang = _box.get(AppConstants.keyLocale, defaultValue: 'tr');
    return Locale(lang);
  }

  Future<void> setLocale(String languageCode) async {
    await _box.put(AppConstants.keyLocale, languageCode);
    notifyListeners();
  }

  bool get isTurkish => locale.languageCode == 'tr';

  bool get globalSilent =>
      _box.get(AppConstants.keyGlobalSilent, defaultValue: false);

  Future<void> setGlobalSilent(bool val) async {
    await _box.put(AppConstants.keyGlobalSilent, val);
    notifyListeners();
  }

  bool get globalVibration =>
      _box.get(AppConstants.keyGlobalVibration, defaultValue: true);

  Future<void> setGlobalVibration(bool val) async {
    await _box.put(AppConstants.keyGlobalVibration, val);
    notifyListeners();
  }

  bool get onboardingDone =>
      _box.get(AppConstants.keyOnboardingDone, defaultValue: false);

  Future<void> setOnboardingDone() async {
    await _box.put(AppConstants.keyOnboardingDone, true);
    notifyListeners();
  }
}
