import 'package:flutter/material.dart';

export 'app_theme_colors.dart';

import 'app_theme_colors.dart';

abstract final class AppColors {
  static const Color seed = Color(0xFF2457C5);
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
    return _buildTheme(
      brightness: Brightness.light,
      colors: AppThemeColors.light,
    );
  }

  static ThemeData dark() {
    return _buildTheme(
      brightness: Brightness.dark,
      colors: AppThemeColors.dark,
    );
  }

  static ThemeData _buildTheme({
    required Brightness brightness,
    required AppThemeColors colors,
  }) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.seed,
      brightness: brightness,
    );
    final baseTheme = brightness == Brightness.light
        ? ThemeData.light()
        : ThemeData.dark();

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme.copyWith(
        surface: colors.cardBackground,
        outlineVariant: colors.border,
        onSurface: colors.textPrimary,
        onSurfaceVariant: colors.textSecondary,
      ),
      scaffoldBackgroundColor: colors.canvas,
      textTheme: baseTheme.textTheme.apply(
        bodyColor: colors.textPrimary,
        displayColor: colors.textPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colors.cardBackground.withValues(
          alpha: brightness == Brightness.light ? 0.94 : 0.92,
        ),
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
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colors.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: BorderSide(color: colors.border),
        ),
        side: BorderSide(color: colors.border),
      ),
      dividerColor: colors.border,
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
      extensions: <ThemeExtension<dynamic>>[colors],
    );
  }
}
