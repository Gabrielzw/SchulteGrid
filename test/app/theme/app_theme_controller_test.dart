import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:schulte_grid/app/theme/app_theme_controller.dart';
import 'package:schulte_grid/app/theme/app_theme_mode.dart';

void main() {
  test('loads saved theme mode from shared preferences', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      AppThemeController.storageKey: AppThemeMode.dark.storageValue,
    });
    final preferences = await SharedPreferences.getInstance();

    final controller = AppThemeController(preferences: preferences);

    expect(controller.selectedMode.value, AppThemeMode.dark);
  });

  test('persists updated theme mode', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final preferences = await SharedPreferences.getInstance();
    final controller = AppThemeController(preferences: preferences);

    await controller.updateThemeMode(AppThemeMode.light);

    expect(
      preferences.getString(AppThemeController.storageKey),
      AppThemeMode.light.storageValue,
    );
  });
}
