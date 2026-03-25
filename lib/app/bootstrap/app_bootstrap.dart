import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/database/app_database.dart';
import '../../data/repositories/isar_training_record_repository.dart';
import '../../data/repositories/training_record_repository.dart';
import '../theme/app_theme_controller.dart';

abstract final class AppBootstrap {
  static Future<void> init() async {
    final preferences = await SharedPreferences.getInstance();
    final database = await AppDatabase.create();
    final repository = IsarTrainingRecordRepository(database.instance);
    final themeController = AppThemeController(preferences: preferences);

    Get.put<SharedPreferences>(preferences, permanent: true);
    Get.put<AppDatabase>(database, permanent: true);
    Get.put<TrainingRecordRepository>(repository, permanent: true);
    Get.put<AppThemeController>(themeController, permanent: true);
  }
}
