import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_theme.dart';
import '../../../app/widgets/section_card.dart';
import '../controllers/settings_controller.dart';

class DataBackupSection extends GetView<SettingsController> {
  const DataBackupSection({super.key});

  @override
  Widget build(BuildContext context) {
    final AppThemeColors palette = context.appColors;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Obx(() {
      final bool isBusy = controller.isBusy;
      final String? statusMessage = controller.statusMessage.value;

      return SectionCard(
        title: '数据备份与恢复',
        subtitle: '导出训练记录与应用配置为 JSON 文件；恢复时会覆盖当前本地数据。',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: isBusy
                    ? null
                    : () => unawaited(controller.exportBackup()),
                icon: const Icon(Icons.file_upload_outlined),
                label: Text(
                  isBusy && controller.isExporting.value ? '正在导出...' : '导出备份',
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: isBusy
                    ? null
                    : () => unawaited(controller.restoreBackup()),
                icon: const Icon(Icons.restore_page_outlined),
                label: Text(
                  isBusy && controller.isRestoring.value ? '正在恢复...' : '恢复备份',
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              '当前备份内容包括训练数据和主题模式配置，后续新增设置项后会统一纳入此备份文件。',
              style: textTheme.bodyMedium?.copyWith(
                color: palette.textSecondary,
                height: 1.6,
              ),
            ),
            if (statusMessage != null) ...<Widget>[
              const SizedBox(height: AppSpacing.sm),
              Text(
                statusMessage,
                style: textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  height: 1.5,
                ),
              ),
            ],
            if (isBusy) ...<Widget>[
              const SizedBox(height: AppSpacing.md),
              const LinearProgressIndicator(),
            ],
          ],
        ),
      );
    });
  }
}
