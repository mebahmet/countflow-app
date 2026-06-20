import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand colors
  static const Color deepNight = Color(0xFF1A0E3D);
  static const Color darkPurple = Color(0xFF26215C);
  static const Color brandPurple = Color(0xFF534AB7);
  static const Color midPurple = Color(0xFF7F77DD);
  static const Color lightPurple = Color(0xFFAFA9EC);
  static const Color softPurple = Color(0xFFCECBF6);
  static const Color palePurple = Color(0xFFEEEDFE);

  static const Color tealAccent = Color(0xFF1D9E75);
  static const Color tealLight = Color(0xFF5DCAA5);
  static const Color redAccent = Color(0xFFE24B4A);
  static const Color amberAccent = Color(0xFFEF9F27);
  static const Color greenAccent = Color(0xFF639922);

  static const Color surface = Color(0xFFF8F7FF);
  static const Color cardDark = Color(0xFF231650);
  static const Color cardDarker = Color(0xFF1E1244);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: midPurple,
        secondary: tealAccent,
        surface: deepNight,
        surfaceContainerHighest: cardDark,
        onPrimary: deepNight,
        onSecondary: Colors.white,
        onSurface: Color(0xFFEEEDFE),
        error: redAccent,
        tertiary: amberAccent,
      ),
      scaffoldBackgroundColor: deepNight,
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: GoogleFonts.inter(
          fontSize: 64,
          fontWeight: FontWeight.w500,
          color: palePurple,
          fontFeatures: [const FontFeature.tabularFigures()],
        ),
        displayMedium: GoogleFonts.inter(
          fontSize: 48,
          fontWeight: FontWeight.w500,
          color: palePurple,
          fontFeatures: [const FontFeature.tabularFigures()],
        ),
        headlineLarge: GoogleFonts.inter(
          fontSize: 28,
          fontWeight: FontWeight.w500,
          color: palePurple,
        ),
        headlineMedium: GoogleFonts.inter(
          fontSize: 22,
          fontWeight: FontWeight.w500,
          color: softPurple,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: softPurple,
        ),
        titleMedium: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: lightPurple,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: lightPurple,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: midPurple,
        ),
        labelSmall: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: midPurple,
          letterSpacing: 0.08,
        ),
      ),
      cardTheme: CardTheme(
        color: cardDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0x33534AB7), width: 0.5),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: deepNight,
        foregroundColor: palePurple,
        elevation: 0,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: palePurple,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: brandPurple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      dividerColor: const Color(0x22534AB7),
      extensions: const [AppColors.dark],
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: brandPurple,
        secondary: tealAccent,
        surface: Colors.white,
        surfaceContainerHighest: palePurple,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: darkPurple,
        error: redAccent,
        tertiary: amberAccent,
      ),
      scaffoldBackgroundColor: const Color(0xFFF4F2FF),
      textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme).copyWith(
        displayLarge: GoogleFonts.inter(
          fontSize: 64,
          fontWeight: FontWeight.w500,
          color: darkPurple,
          fontFeatures: [const FontFeature.tabularFigures()],
        ),
        displayMedium: GoogleFonts.inter(
          fontSize: 48,
          fontWeight: FontWeight.w500,
          color: darkPurple,
          fontFeatures: [const FontFeature.tabularFigures()],
        ),
        headlineLarge: GoogleFonts.inter(
          fontSize: 28,
          fontWeight: FontWeight.w500,
          color: darkPurple,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: darkPurple,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          color: const Color(0xFF3C3489),
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          color: brandPurple,
        ),
        labelSmall: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: brandPurple,
          letterSpacing: 0.08,
        ),
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0x22534AB7), width: 0.5),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFFF4F2FF),
        foregroundColor: darkPurple,
        elevation: 0,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: darkPurple,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: brandPurple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      dividerColor: const Color(0x22534AB7),
      extensions: const [AppColors.light],
    );
  }
}

@immutable
class AppColors extends ThemeExtension<AppColors> {
  final Color cardBg;
  final Color cardBorder;
  final Color counterText;
  final Color labelText;
  final Color progressBg;

  const AppColors({
    required this.cardBg,
    required this.cardBorder,
    required this.counterText,
    required this.labelText,
    required this.progressBg,
  });

  static const dark = AppColors(
    cardBg: Color(0x40534AB7),
    cardBorder: Color(0x557F77DD),
    counterText: Color(0xFFEEEDFE),
    labelText: Color(0xFFAFA9EC),
    progressBg: Color(0x33534AB7),
  );

  static const light = AppColors(
    cardBg: Colors.white,
    cardBorder: Color(0x33534AB7),
    counterText: Color(0xFF26215C),
    labelText: Color(0xFF534AB7),
    progressBg: Color(0x22534AB7),
  );

  @override
  AppColors copyWith({
    Color? cardBg,
    Color? cardBorder,
    Color? counterText,
    Color? labelText,
    Color? progressBg,
  }) {
    return AppColors(
      cardBg: cardBg ?? this.cardBg,
      cardBorder: cardBorder ?? this.cardBorder,
      counterText: counterText ?? this.counterText,
      labelText: labelText ?? this.labelText,
      progressBg: progressBg ?? this.progressBg,
    );
  }

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      cardBg: Color.lerp(cardBg, other.cardBg, t)!,
      cardBorder: Color.lerp(cardBorder, other.cardBorder, t)!,
      counterText: Color.lerp(counterText, other.counterText, t)!,
      labelText: Color.lerp(labelText, other.labelText, t)!,
      progressBg: Color.lerp(progressBg, other.progressBg, t)!,
    );
  }
}

// Category colors for counter cards
class CategoryColors {
  static const Map<CounterCategory, Color> primary = {
    CounterCategory.general: Color(0xFF7F77DD),
    CounterCategory.dhikr: Color(0xFF1D9E75),
    CounterCategory.health: Color(0xFFE24B4A),
    CounterCategory.sport: Color(0xFFEF9F27),
    CounterCategory.work: Color(0xFF378ADD),
    CounterCategory.habit: Color(0xFF639922),
    CounterCategory.score: Color(0xFFD4537E),
  };

  static const Map<CounterCategory, Color> light = {
    CounterCategory.general: Color(0xFFEEEDFE),
    CounterCategory.dhikr: Color(0xFFE1F5EE),
    CounterCategory.health: Color(0xFFFCEBEB),
    CounterCategory.sport: Color(0xFFFAEEDA),
    CounterCategory.work: Color(0xFFE6F1FB),
    CounterCategory.habit: Color(0xFFEAF3DE),
    CounterCategory.score: Color(0xFFFBEAF0),
  };

  static const Map<CounterCategory, String> emoji = {
    CounterCategory.general: '🔢',
    CounterCategory.dhikr: '📿',
    CounterCategory.health: '💊',
    CounterCategory.sport: '🏋️',
    CounterCategory.work: '💼',
    CounterCategory.habit: '✅',
    CounterCategory.score: '🎯',
  };
}

enum CounterCategory { general, dhikr, health, sport, work, habit, score }
