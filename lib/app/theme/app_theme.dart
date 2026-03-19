import 'package:flutter/material.dart';

abstract final class AppColors {
  static const Color seed = Color(0xFF2457C5);
  static const Color canvas = Color(0xFFF4F6FB);
  static const Color card = Colors.white;
  static const Color border = Color(0xFFDDE3F0);
  static const Color shellTop = Color(0xFFF8FAFF);
  static const Color shellBottom = Color(0xFFEEF2FB);
  static const Color surfaceMuted = Color(0xFFE9EEF6);
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF7A8599);
  static const Color errorSoft = Color(0xFFFFEFEF);
  static const Color errorBorder = Color(0xFFFFCFCF);
}

abstract final class AppSpacing {
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
}

abstract final class AppRadius {
  static const double md = 20;
  static const double lg = 28;
}

final class AppTheme {
  const AppTheme._();

  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.seed,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme.copyWith(
        surface: AppColors.card,
        outlineVariant: AppColors.border,
      ),
      scaffoldBackgroundColor: AppColors.canvas,
      textTheme: ThemeData.light().textTheme.apply(
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white.withValues(alpha: 0.94),
        indicatorColor: colorScheme.primaryContainer,
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          backgroundColor: AppColors.seed,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: const BorderSide(color: AppColors.border),
        ),
        side: const BorderSide(color: AppColors.border),
      ),
    );
  }
}
