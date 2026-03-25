import 'package:get/get.dart';

import '../../../data/repositories/training_record_repository.dart';
import '../../../data/services/app_data_backup_service.dart';
import '../../../data/services/backup_file_access.dart';
import '../../history/controllers/history_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../settings/controllers/settings_controller.dart';
import '../../stats/controllers/stats_controller.dart';
import '../controllers/root_controller.dart';

class RootBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RootController>(RootController.new);
    Get.lazyPut<HomeController>(HomeController.new);
    Get.lazyPut<StatsController>(
      () => StatsController(repository: Get.find<TrainingRecordRepository>()),
    );
    Get.lazyPut<HistoryController>(
      () => HistoryController(repository: Get.find<TrainingRecordRepository>()),
    );
    Get.lazyPut<SettingsController>(
      () => SettingsController(
        backupService: Get.find<AppDataBackupService>(),
        backupFileAccess: Get.find<BackupFileAccess>(),
      ),
    );
  }
}
