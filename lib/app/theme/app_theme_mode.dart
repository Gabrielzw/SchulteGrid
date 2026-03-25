import 'package:flutter/material.dart';

enum AppThemeMode {
  system(
    label: '跟随系统',
    storageValue: 'system',
    materialMode: ThemeMode.system,
    icon: Icons.brightness_auto_rounded,
  ),
  light(
    label: '浅色',
    storageValue: 'light',
    materialMode: ThemeMode.light,
    icon: Icons.light_mode_rounded,
  ),
  dark(
    label: '深色',
    storageValue: 'dark',
    materialMode: ThemeMode.dark,
    icon: Icons.dark_mode_rounded,
  );

  const AppThemeMode({
    required this.label,
    required this.storageValue,
    required this.materialMode,
    required this.icon,
  });

  final String label;
  final String storageValue;
  final ThemeMode materialMode;
  final IconData icon;

  static AppThemeMode fromStorageValue(String? value) {
    return values.firstWhere(
      (AppThemeMode mode) => mode.storageValue == value,
      orElse: () => AppThemeMode.system,
    );
  }
}
