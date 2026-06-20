class AppConstants {
  static const String countersBox = 'counters';
  static const String entriesBox = 'tally_entries';
  static const String settingsBox = 'settings';

  static const String keyThemeMode = 'theme_mode';
  static const String keyLocale = 'locale';
  static const String keyOnboardingDone = 'onboarding_done';
  static const String keyDefaultStep = 'default_step';
  static const String keyGlobalSilent = 'global_silent';
  static const String keyGlobalVibration = 'global_vibration';

  // Dhikr presets
  static const List<Map<String, String>> dhikrPresets = [
    {'ar': 'سُبْحَانَ اللَّهِ', 'tr': 'Sübhanallah', 'en': 'Subhanallah', 'goal': '33'},
    {'ar': 'الْحَمْدُ لِلَّهِ', 'tr': 'Elhamdülillah', 'en': 'Alhamdulillah', 'goal': '33'},
    {'ar': 'اللَّهُ أَكْبَرُ', 'tr': 'Allahu Ekber', 'en': 'Allahu Akbar', 'goal': '34'},
    {'ar': 'لَا إِلَهَ إِلَّا اللَّهُ', 'tr': 'La ilahe illallah', 'en': 'La ilaha illallah', 'goal': '100'},
    {'ar': 'اسْتَغْفِرُ اللَّهَ', 'tr': 'Estağfirullah', 'en': 'Astaghfirullah', 'goal': '100'},
    {'ar': 'صَلِّ عَلَى مُحَمَّدٍ', 'tr': 'Salavat', 'en': 'Salawat', 'goal': '100'},
  ];

  static const int maxCounters = 300;
  static const int maxCounterValue = 999999;
  static const int minCounterValue = -999999;
}
