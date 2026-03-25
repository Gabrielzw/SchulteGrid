import '../models/app_settings_snapshot.dart';

abstract interface class AppSettingsRepository {
  Future<AppSettingsSnapshot> readSnapshot();

  Future<void> replaceSnapshot(AppSettingsSnapshot snapshot);
}
