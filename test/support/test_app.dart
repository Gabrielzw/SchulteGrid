import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:schulte_grid/app/theme/app_theme.dart';
import 'package:schulte_grid/app/theme/app_theme_controller.dart';
import 'package:schulte_grid/app/theme/app_theme_mode.dart';
import 'package:schulte_grid/data/repositories/shared_preferences_app_settings_repository.dart';
import 'package:schulte_grid/data/repositories/training_record_repository.dart';
import 'package:schulte_grid/data/services/app_data_backup_service.dart';
import 'package:schulte_grid/data/services/backup_file_access.dart';
import 'package:schulte_grid/modules/settings/controllers/settings_controller.dart';

import 'fakes/fake_backup_file_access.dart';
import 'fakes/fake_training_record_repository.dart';

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

Future<void> registerTestSettingsController({
  AppThemeMode initialMode = AppThemeMode.system,
  TrainingRecordRepository? repository,
  BackupFileAccess? backupFileAccess,
}) async {
  await registerTestThemeController(initialMode: initialMode);

  final themeController = Get.find<AppThemeController>();
  final settingsRepository = SharedPreferencesAppSettingsRepository(
    themeController: themeController,
  );
  final recordRepository = repository ?? FakeTrainingRecordRepository();
  final fileAccess = backupFileAccess ?? FakeBackupFileAccess();
  final backupService = AppDataBackupService(
    trainingRecordRepository: recordRepository,
    settingsRepository: settingsRepository,
  );

  Get.put<TrainingRecordRepository>(recordRepository, permanent: true);
  Get.put<BackupFileAccess>(fileAccess, permanent: true);
  Get.put<AppDataBackupService>(backupService, permanent: true);
  Get.put<SettingsController>(
    SettingsController(
      backupService: backupService,
      backupFileAccess: fileAccess,
    ),
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
