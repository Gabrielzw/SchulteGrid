import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';
import '../widgets/data_backup_section.dart';
import '../widgets/theme_mode_section.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        40,
        AppSpacing.lg,
        AppSpacing.xl,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _SettingsHeader(),
              SizedBox(height: 28),
              ThemeModeSection(),
              SizedBox(height: AppSpacing.lg),
              DataBackupSection(),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsHeader extends StatelessWidget {
  const _SettingsHeader();

  @override
  Widget build(BuildContext context) {
    final palette = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '设置',
          style: textTheme.displaySmall?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          '管理应用的显示偏好，主题切换会立即同步到训练、成绩和历史页面。',
          style: textTheme.titleMedium?.copyWith(
            color: palette.textSecondary,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}
