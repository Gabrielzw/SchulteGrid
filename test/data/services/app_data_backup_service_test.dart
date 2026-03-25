import 'package:flutter_test/flutter_test.dart';
import 'package:schulte_grid/app/theme/app_theme_mode.dart';
import 'package:schulte_grid/data/models/app_backup_data.dart';
import 'package:schulte_grid/data/models/app_settings_snapshot.dart';
import 'package:schulte_grid/data/models/training_record.dart';
import 'package:schulte_grid/data/services/app_data_backup_service.dart';

import '../../support/fakes/fake_app_settings_repository.dart';
import '../../support/fakes/fake_training_record_repository.dart';

void main() {
  test('createBackupJson 包含训练记录和主题配置', () async {
    final repository = FakeTrainingRecordRepository(<TrainingRecord>[
      _buildRecord(
        id: 7,
        mode: 'numbers',
        order: 'ascending',
        completedAt: DateTime(2025, 1, 2, 10, 30),
      ),
    ]);
    final settingsRepository = FakeAppSettingsRepository(
      const AppSettingsSnapshot(themeMode: AppThemeMode.dark),
    );
    final service = AppDataBackupService(
      trainingRecordRepository: repository,
      settingsRepository: settingsRepository,
    );

    final String json = await service.createBackupJson();
    final AppBackupData backup = AppBackupData.fromJsonString(json);

    expect(backup.settings.themeMode, AppThemeMode.dark);
    expect(backup.trainingRecords, hasLength(1));
    expect(backup.trainingRecords.single.id, 7);
    expect(backup.trainingRecords.single.mode, 'numbers');
  });

  test('restoreFromJson 会覆盖训练数据和应用配置', () async {
    final repository = FakeTrainingRecordRepository(<TrainingRecord>[
      _buildRecord(
        id: 1,
        mode: 'letters',
        order: 'descending',
        completedAt: DateTime(2024, 12, 31, 22),
      ),
    ]);
    final settingsRepository = FakeAppSettingsRepository(
      const AppSettingsSnapshot(themeMode: AppThemeMode.light),
    );
    final service = AppDataBackupService(
      trainingRecordRepository: repository,
      settingsRepository: settingsRepository,
    );
    final backup = AppBackupData(
      createdAt: DateTime(2025, 2, 1, 9),
      settings: const AppSettingsSnapshot(themeMode: AppThemeMode.dark),
      trainingRecords: <TrainingRecord>[
        _buildRecord(
          id: 9,
          mode: 'numbers',
          order: 'ascending',
          completedAt: DateTime(2025, 2, 1, 8, 45),
        ),
      ],
    );

    final BackupRestoreSummary summary = await service.restoreFromJson(
      backup.toJsonString(),
    );

    expect(summary.trainingRecordCount, 1);
    expect(settingsRepository.snapshot.themeMode, AppThemeMode.dark);
    expect(repository.savedRecords, hasLength(1));
    expect(repository.savedRecords.single.id, 9);
    expect(repository.savedRecords.single.mode, 'numbers');
  });

  test('restoreFromJson 遇到不支持的备份版本时抛出异常', () async {
    final service = AppDataBackupService(
      trainingRecordRepository: FakeTrainingRecordRepository(),
      settingsRepository: FakeAppSettingsRepository(
        const AppSettingsSnapshot(themeMode: AppThemeMode.system),
      ),
    );

    expect(
      () => service.restoreFromJson('''
        {
          "schemaVersion": 99,
          "createdAt": "2025-02-01T09:00:00.000",
          "settings": {"themeMode": "system"},
          "trainingRecords": []
        }
        '''),
      throwsFormatException,
    );
  });
}

TrainingRecord _buildRecord({
  required int id,
  required String mode,
  required String order,
  required DateTime completedAt,
}) {
  return TrainingRecord()
    ..id = id
    ..mode = mode
    ..order = order
    ..gridSize = 5
    ..durationInMilliseconds = 3210
    ..errorCount = 1
    ..completedAt = completedAt;
}
