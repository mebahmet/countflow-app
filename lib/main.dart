import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_constants.dart';
import 'core/models/counter_model.dart';
import 'core/models/tally_entry_model.dart';
import 'core/providers/counter_provider.dart';
import 'core/providers/settings_provider.dart';
import 'features/counter/screens/home_screen.dart';
import 'l10n/app_localizations.dart';
import 'shared/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(CounterModelAdapter());
  Hive.registerAdapter(TallyEntryModelAdapter());
  Hive.registerAdapter(CounterCategoryAdapter());

  await Hive.openBox<CounterModel>(AppConstants.countersBox);
  await Hive.openBox<TallyEntryModel>(AppConstants.entriesBox);
  await Hive.openBox(AppConstants.settingsBox);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => CounterProvider()),
      ],
      child: const CountFlowApp(),
    ),
  );
}

class CountFlowApp extends StatelessWidget {
  const CountFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    return MaterialApp(
      title: 'SAY / CountFlow',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: settings.themeMode,
      locale: settings.locale,
      supportedLocales: const [
        Locale('tr'),
        Locale('en'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const HomeScreen(),
    );
  }
}
