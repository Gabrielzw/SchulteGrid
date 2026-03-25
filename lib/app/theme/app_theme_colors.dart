import 'package:flutter/material.dart';

@immutable
class AppThemeColors extends ThemeExtension<AppThemeColors> {
  const AppThemeColors({
    required this.canvas,
    required this.cardBackground,
    required this.surfaceMuted,
    required this.surfaceStrong,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
    required this.shellTop,
    required this.shellBottom,
    required this.errorSoft,
    required this.errorBorder,
    required this.errorForeground,
    required this.shadowColor,
    required this.gridCellBackground,
    required this.gridCellHighlightBackground,
    required this.gridCellHighlightBorder,
    required this.gridCellErrorBackground,
    required this.gridCellErrorForeground,
  });

  static const AppThemeColors light = AppThemeColors(
    canvas: Color(0xFFF4F6FB),
    cardBackground: Colors.white,
    surfaceMuted: Color(0xFFE9EEF6),
    surfaceStrong: Color(0xFFDCE4EC),
    border: Color(0xFFDDE3F0),
    textPrimary: Color(0xFF1E293B),
    textSecondary: Color(0xFF7A8599),
    shellTop: Color(0xFFF8FAFF),
    shellBottom: Color(0xFFEEF2FB),
    errorSoft: Color(0xFFFFEFEF),
    errorBorder: Color(0xFFFFCFCF),
    errorForeground: Color(0xFF8C2B2B),
    shadowColor: Color(0x0A000000),
    gridCellBackground: Colors.white,
    gridCellHighlightBackground: Color(0xFFDCE6FF),
    gridCellHighlightBorder: Color(0xFF8EABF0),
    gridCellErrorBackground: Color(0xFFFCE8E9),
    gridCellErrorForeground: Color(0xFFB3261E),
  );

  static const AppThemeColors dark = AppThemeColors(
    canvas: Color(0xFF08111F),
    cardBackground: Color(0xFF111C2E),
    surfaceMuted: Color(0xFF162237),
    surfaceStrong: Color(0xFF21314B),
    border: Color(0xFF263756),
    textPrimary: Color(0xFFE5ECF6),
    textSecondary: Color(0xFFA5B4CC),
    shellTop: Color(0xFF0B1528),
    shellBottom: Color(0xFF08111F),
    errorSoft: Color(0xFF3D1720),
    errorBorder: Color(0xFF7A2335),
    errorForeground: Color(0xFFFFC1BF),
    shadowColor: Color(0x52000000),
    gridCellBackground: Color(0xFF142138),
    gridCellHighlightBackground: Color(0xFF17335F),
    gridCellHighlightBorder: Color(0xFF6E9BFF),
    gridCellErrorBackground: Color(0xFF4D1F29),
    gridCellErrorForeground: Color(0xFFFFB4AB),
  );

  final Color canvas;
  final Color cardBackground;
  final Color surfaceMuted;
  final Color surfaceStrong;
  final Color border;
  final Color textPrimary;
  final Color textSecondary;
  final Color shellTop;
  final Color shellBottom;
  final Color errorSoft;
  final Color errorBorder;
  final Color errorForeground;
  final Color shadowColor;
  final Color gridCellBackground;
  final Color gridCellHighlightBackground;
  final Color gridCellHighlightBorder;
  final Color gridCellErrorBackground;
  final Color gridCellErrorForeground;

  @override
  AppThemeColors copyWith({
    Color? canvas,
    Color? cardBackground,
    Color? surfaceMuted,
    Color? surfaceStrong,
    Color? border,
    Color? textPrimary,
    Color? textSecondary,
    Color? shellTop,
    Color? shellBottom,
    Color? errorSoft,
    Color? errorBorder,
    Color? errorForeground,
    Color? shadowColor,
    Color? gridCellBackground,
    Color? gridCellHighlightBackground,
    Color? gridCellHighlightBorder,
    Color? gridCellErrorBackground,
    Color? gridCellErrorForeground,
  }) {
    return AppThemeColors(
      canvas: canvas ?? this.canvas,
      cardBackground: cardBackground ?? this.cardBackground,
      surfaceMuted: surfaceMuted ?? this.surfaceMuted,
      surfaceStrong: surfaceStrong ?? this.surfaceStrong,
      border: border ?? this.border,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      shellTop: shellTop ?? this.shellTop,
      shellBottom: shellBottom ?? this.shellBottom,
      errorSoft: errorSoft ?? this.errorSoft,
      errorBorder: errorBorder ?? this.errorBorder,
      errorForeground: errorForeground ?? this.errorForeground,
      shadowColor: shadowColor ?? this.shadowColor,
      gridCellBackground: gridCellBackground ?? this.gridCellBackground,
      gridCellHighlightBackground:
          gridCellHighlightBackground ?? this.gridCellHighlightBackground,
      gridCellHighlightBorder:
          gridCellHighlightBorder ?? this.gridCellHighlightBorder,
      gridCellErrorBackground:
          gridCellErrorBackground ?? this.gridCellErrorBackground,
      gridCellErrorForeground:
          gridCellErrorForeground ?? this.gridCellErrorForeground,
    );
  }

  @override
  AppThemeColors lerp(ThemeExtension<AppThemeColors>? other, double t) {
    if (other is! AppThemeColors) {
      return this;
    }

    return AppThemeColors(
      canvas: Color.lerp(canvas, other.canvas, t)!,
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
      surfaceMuted: Color.lerp(surfaceMuted, other.surfaceMuted, t)!,
      surfaceStrong: Color.lerp(surfaceStrong, other.surfaceStrong, t)!,
      border: Color.lerp(border, other.border, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      shellTop: Color.lerp(shellTop, other.shellTop, t)!,
      shellBottom: Color.lerp(shellBottom, other.shellBottom, t)!,
      errorSoft: Color.lerp(errorSoft, other.errorSoft, t)!,
      errorBorder: Color.lerp(errorBorder, other.errorBorder, t)!,
      errorForeground: Color.lerp(errorForeground, other.errorForeground, t)!,
      shadowColor: Color.lerp(shadowColor, other.shadowColor, t)!,
      gridCellBackground: Color.lerp(
        gridCellBackground,
        other.gridCellBackground,
        t,
      )!,
      gridCellHighlightBackground: Color.lerp(
        gridCellHighlightBackground,
        other.gridCellHighlightBackground,
        t,
      )!,
      gridCellHighlightBorder: Color.lerp(
        gridCellHighlightBorder,
        other.gridCellHighlightBorder,
        t,
      )!,
      gridCellErrorBackground: Color.lerp(
        gridCellErrorBackground,
        other.gridCellErrorBackground,
        t,
      )!,
      gridCellErrorForeground: Color.lerp(
        gridCellErrorForeground,
        other.gridCellErrorForeground,
        t,
      )!,
    );
  }
}

extension AppThemeContextExtension on BuildContext {
  AppThemeColors get appColors {
    final colors = Theme.of(this).extension<AppThemeColors>();
    if (colors == null) {
      throw StateError('AppThemeColors 未注入当前 ThemeData。');
    }

    return colors;
  }
}

Color resolveAdaptiveTone(BuildContext context, Color tone) {
  if (Theme.of(context).brightness == Brightness.light) {
    return tone;
  }

  return Color.alphaBlend(
    tone.withValues(alpha: 0.28),
    context.appColors.surfaceMuted,
  );
}
