import '../../app/theme/app_theme_mode.dart';

class AppSettingsSnapshot {
  const AppSettingsSnapshot({required this.themeMode});

  static const String themeModeKey = 'themeMode';

  final AppThemeMode themeMode;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{themeModeKey: themeMode.storageValue};
  }

  factory AppSettingsSnapshot.fromJson(Map<String, dynamic> json) {
    final Object? themeModeValue = json[themeModeKey];
    if (themeModeValue is! String) {
      throw const FormatException('备份文件缺少有效的主题模式配置。');
    }

    final AppThemeMode? themeMode = AppThemeMode.tryFromStorageValue(
      themeModeValue,
    );
    if (themeMode == null) {
      throw FormatException('备份文件包含未知主题模式：$themeModeValue');
    }

    return AppSettingsSnapshot(themeMode: themeMode);
  }
}
