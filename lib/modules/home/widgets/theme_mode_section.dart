import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_theme.dart';
import '../../../app/theme/app_theme_controller.dart';
import '../../../app/theme/app_theme_mode.dart';

class ThemeModeSection extends GetView<AppThemeController> {
  const ThemeModeSection({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.appColors;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Obx(() {
      final selectedMode = controller.selectedMode.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _SectionHeader(
            title: '主题模式',
            trailing: selectedMode == AppThemeMode.system ? '跟随系统' : '立即生效',
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            decoration: BoxDecoration(
              color: palette.surfaceMuted,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            padding: const EdgeInsets.all(4),
            child: Row(
              children: AppThemeMode.values
                  .map(
                    (AppThemeMode mode) => Expanded(
                      child: _ThemeModeOptionCard(
                        label: mode.label,
                        icon: mode.icon,
                        isSelected: selectedMode == mode,
                        selectedColor: colorScheme.primary,
                        onTap: () =>
                            unawaited(controller.updateThemeMode(mode)),
                      ),
                    ),
                  )
                  .toList(growable: false),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '切换浅色、深色或跟随系统显示，训练页和统计页会同步适配。',
            style: textTheme.bodySmall?.copyWith(
              color: palette.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      );
    });
  }
}

class _ThemeModeOptionCard extends StatelessWidget {
  const _ThemeModeOptionCard({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.selectedColor,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final Color selectedColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.appColors;
    final foregroundColor = isSelected ? selectedColor : palette.textPrimary;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      height: 72,
      decoration: BoxDecoration(
        color: isSelected ? palette.cardBackground : Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.md - 4),
        border: Border.all(
          color: isSelected
              ? selectedColor.withValues(alpha: 0.22)
              : Colors.transparent,
        ),
        boxShadow: isSelected
            ? <BoxShadow>[
                BoxShadow(
                  color: palette.shadowColor,
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ]
            : const <BoxShadow>[],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.md - 4),
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(icon, size: 20, color: foregroundColor),
              const SizedBox(height: AppSpacing.xs),
              Text(
                label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: foregroundColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.trailing});

  final String title;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    final palette = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            title,
            style: textTheme.titleSmall?.copyWith(
              color: palette.textPrimary,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
        ),
        if (trailing != null)
          Text(
            trailing!,
            style: textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
      ],
    );
  }
}
