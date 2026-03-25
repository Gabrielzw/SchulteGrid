import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:schulte_grid/app/theme/app_theme.dart';
import 'package:schulte_grid/app/theme/app_theme_controller.dart';
import 'package:schulte_grid/app/theme/app_theme_mode.dart';

Future<void> registerTestThemeController({
  AppThemeMode initialMode = AppThemeMode.system,
}) async {
  SharedPreferences.setMockInitialValues(<String, Object>{
    AppThemeController.storageKey: initialMode.storageValue,
  });
  final preferences = await SharedPreferences.getInstance();

  Get.put<SharedPreferences>(preferences, permanent: true);
  Get.put<AppThemeController>(
    AppThemeController(preferences: preferences),
    permanent: true,
  );
}

Widget buildTestApp(Widget home, {ThemeMode themeMode = ThemeMode.light}) {
  return GetMaterialApp(
    theme: AppTheme.light(),
    darkTheme: AppTheme.dark(),
    themeMode: themeMode,
    home: home,
  );
}
