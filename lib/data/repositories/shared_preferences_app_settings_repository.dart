import '../../app/theme/app_theme_controller.dart';
import '../models/app_settings_snapshot.dart';
import 'app_settings_repository.dart';

class SharedPreferencesAppSettingsRepository implements AppSettingsRepository {
  const SharedPreferencesAppSettingsRepository({
    required AppThemeController themeController,
  }) : _themeController = themeController;

  final AppThemeController _themeController;

  @override
  Future<AppSettingsSnapshot> readSnapshot() async {
    return AppSettingsSnapshot(themeMode: _themeController.selectedMode.value);
  }

  @override
  Future<void> replaceSnapshot(AppSettingsSnapshot snapshot) {
    return _themeController.updateThemeMode(snapshot.themeMode);
  }
}
