import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_theme_mode.dart';

class AppThemeController extends GetxController {
  AppThemeController({
    required SharedPreferences preferences,
    AppThemeMode? initialMode,
  }) : _preferences = preferences,
       selectedMode =
           (initialMode ??
                   AppThemeMode.fromStorageValue(
                     preferences.getString(storageKey),
                   ))
               .obs;

  static const String storageKey = 'app_theme_mode';

  final SharedPreferences _preferences;
  final Rx<AppThemeMode> selectedMode;

  Future<void> updateThemeMode(AppThemeMode mode) async {
    if (selectedMode.value == mode) {
      return;
    }

    selectedMode.value = mode;
    final isSaved = await _preferences.setString(storageKey, mode.storageValue);
    if (!isSaved) {
      throw StateError('主题模式保存失败。');
    }
  }
}
