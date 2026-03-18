import 'package:get/get.dart';

import '../../data/database/app_database.dart';
import '../../data/repositories/isar_training_record_repository.dart';
import '../../data/repositories/training_record_repository.dart';

abstract final class AppBootstrap {
  static Future<void> init() async {
    final database = await AppDatabase.create();
    final repository = IsarTrainingRecordRepository(database.instance);

    Get.put<AppDatabase>(database, permanent: true);
    Get.put<TrainingRecordRepository>(repository, permanent: true);
  }
}
