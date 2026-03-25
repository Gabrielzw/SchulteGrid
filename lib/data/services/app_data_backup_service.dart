import '../models/app_backup_data.dart';
import '../repositories/app_settings_repository.dart';
import '../repositories/training_record_repository.dart';

class AppDataBackupService {
  const AppDataBackupService({
    required TrainingRecordRepository trainingRecordRepository,
    required AppSettingsRepository settingsRepository,
  }) : _trainingRecordRepository = trainingRecordRepository,
       _settingsRepository = settingsRepository;

  final TrainingRecordRepository _trainingRecordRepository;
  final AppSettingsRepository _settingsRepository;

  Future<AppBackupData> createBackup() async {
    final records = await _trainingRecordRepository.fetchAll();
    final settings = await _settingsRepository.readSnapshot();

    return AppBackupData(
      createdAt: DateTime.now(),
      settings: settings,
      trainingRecords: records,
    );
  }

  Future<String> createBackupJson() async {
    final AppBackupData backup = await createBackup();
    return backup.toJsonString();
  }

  Future<BackupRestoreSummary> restoreFromJson(String jsonText) async {
    final AppBackupData backup = AppBackupData.fromJsonString(jsonText);
    await _trainingRecordRepository.replaceAll(backup.trainingRecords);
    await _settingsRepository.replaceSnapshot(backup.settings);
    return BackupRestoreSummary(
      trainingRecordCount: backup.trainingRecords.length,
    );
  }
}

class BackupRestoreSummary {
  const BackupRestoreSummary({required this.trainingRecordCount});

  final int trainingRecordCount;
}
