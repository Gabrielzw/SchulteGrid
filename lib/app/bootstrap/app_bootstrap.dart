import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/database/app_database.dart';
import '../../data/repositories/isar_training_record_repository.dart';
import '../../data/repositories/app_settings_repository.dart';
import '../../data/repositories/shared_preferences_app_settings_repository.dart';
import '../../data/repositories/training_record_repository.dart';
import '../../data/services/app_data_backup_service.dart';
import '../../data/services/backup_file_access.dart';
import '../theme/app_theme_controller.dart';

abstract final class AppBootstrap {
  static Future<void> init() async {
    final preferences = await SharedPreferences.getInstance();
    final database = await AppDatabase.create();
    final repository = IsarTrainingRecordRepository(database.instance);
    final themeController = AppThemeController(preferences: preferences);
    final settingsRepository = SharedPreferencesAppSettingsRepository(
      themeController: themeController,
    );
    final backupService = AppDataBackupService(
      trainingRecordRepository: repository,
      settingsRepository: settingsRepository,
    );

    Get.put<SharedPreferences>(preferences, permanent: true);
    Get.put<AppDatabase>(database, permanent: true);
    Get.put<TrainingRecordRepository>(repository, permanent: true);
    Get.put<AppThemeController>(themeController, permanent: true);
    Get.put<AppSettingsRepository>(settingsRepository, permanent: true);
    Get.put<AppDataBackupService>(backupService, permanent: true);
    Get.put<BackupFileAccess>(FilePickerBackupFileAccess(), permanent: true);
  }
}
