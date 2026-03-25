import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/widgets/app_toast.dart';
import '../../../data/services/app_data_backup_service.dart';
import '../../../data/services/backup_file_access.dart';
import '../../history/controllers/history_controller.dart';
import '../../stats/controllers/stats_controller.dart';

typedef SettingsNowProvider = DateTime Function();

class SettingsController extends GetxController {
  SettingsController({
    required AppDataBackupService backupService,
    required BackupFileAccess backupFileAccess,
    SettingsNowProvider? nowProvider,
  }) : _backupService = backupService,
       _backupFileAccess = backupFileAccess,
       _nowProvider = nowProvider ?? DateTime.now;

  static const String _backupFilePrefix = 'schulte_grid_backup';

  final AppDataBackupService _backupService;
  final BackupFileAccess _backupFileAccess;
  final SettingsNowProvider _nowProvider;

  final RxBool isExporting = false.obs;
  final RxBool isRestoring = false.obs;
  final RxnString statusMessage = RxnString();

  bool get isBusy => isExporting.value || isRestoring.value;

  Future<void> exportBackup() async {
    if (isBusy) {
      return;
    }

    final AppToastHandle syncToast = AppToast.showSync(
      title: '正在同步数据',
      message: '正在整理训练记录和应用配置，请选择导出路径。',
    );
    isExporting.value = true;
    statusMessage.value = null;
    try {
      final String json = await _backupService.createBackupJson();
      final String? savedPath = await _backupFileAccess.saveBackupText(
        suggestedFileName: _buildSuggestedFileName(),
        contents: json,
      );
      if (savedPath == null) {
        await syncToast.closeAndWait();
        return;
      }

      await syncToast.closeAndWait();
      _showSuccess(title: '导出成功', message: '备份文件已保存到：$savedPath');
    } catch (error) {
      await syncToast.closeAndWait();
      _showError(title: '导出备份失败', error: error);
    } finally {
      isExporting.value = false;
    }
  }

  Future<void> restoreBackup() async {
    if (isBusy) {
      return;
    }

    final PickedBackupFile? file = await _backupFileAccess.pickBackupFile();
    if (file == null) {
      return;
    }

    final bool shouldRestore = await _confirmRestore(file.name);
    if (!shouldRestore) {
      return;
    }

    final AppToastHandle syncToast = AppToast.showSync(
      title: '正在同步数据',
      message: '正在恢复训练记录和应用配置，请稍候。',
    );
    isRestoring.value = true;
    statusMessage.value = null;
    try {
      final BackupRestoreSummary summary = await _backupService.restoreFromJson(
        file.contents,
      );
      await _refreshRecordViews();
      await syncToast.closeAndWait();
      _showSuccess(
        title: '恢复成功',
        message: '已从 ${file.name} 恢复 ${summary.trainingRecordCount} 条训练记录。',
      );
    } catch (error) {
      await syncToast.closeAndWait();
      _showError(title: '恢复备份失败', error: error);
    } finally {
      isRestoring.value = false;
    }
  }

  Future<bool> _confirmRestore(String fileName) async {
    final bool? result = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('确认恢复备份'),
        content: Text('将从 $fileName 恢复训练数据和应用配置，并覆盖当前本地内容。是否继续？'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Get.back<bool>(result: false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Get.back<bool>(result: true),
            child: const Text('继续恢复'),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  Future<void> _refreshRecordViews() async {
    if (Get.isRegistered<StatsController>()) {
      await Get.find<StatsController>().refreshRecords();
    }
    if (Get.isRegistered<HistoryController>()) {
      await Get.find<HistoryController>().refreshRecords();
    }
  }

  void _showSuccess({required String title, required String message}) {
    statusMessage.value = message;
    AppToast.showSuccess(title: title, message: message);
  }

  void _showError({required String title, required Object error}) {
    final String message = '$error';
    statusMessage.value = '$title：$message';
    AppToast.showError(title: title, message: message);
  }

  String _buildSuggestedFileName() {
    final DateTime now = _nowProvider();
    final String timestamp =
        '${now.year}${_twoDigits(now.month)}${_twoDigits(now.day)}_'
        '${_twoDigits(now.hour)}${_twoDigits(now.minute)}${_twoDigits(now.second)}';
    return '${_backupFilePrefix}_$timestamp.json';
  }

  String _twoDigits(int value) {
    return value.toString().padLeft(2, '0');
  }
}
