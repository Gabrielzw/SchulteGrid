import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';
import 'training_setup_cards.dart';

class TrainingSetupHeader extends StatelessWidget {
  const TrainingSetupHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '训练设置',
          style: textTheme.displaySmall?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          '选择本轮专注训练的网格尺寸、内容模式和点击顺序。',
          style: textTheme.titleMedium?.copyWith(
            color: palette.textSecondary,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}

class TrainingGridSizeSelector extends StatelessWidget {
  const TrainingGridSizeSelector({
    required this.gridSizes,
    required this.selectedGridSize,
    required this.onSelected,
    super.key,
  });

  final List<int> gridSizes;
  final int? selectedGridSize;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const _SectionHeader(title: '网格尺寸', trailing: '推荐：5 × 5'),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: gridSizes
              .asMap()
              .entries
              .map((entry) {
                final index = entry.key;
                final size = entry.value;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: index == gridSizes.length - 1 ? 0 : AppSpacing.sm,
                    ),
                    child: TrainingGridSizeCard(
                      size: size,
                      isSelected: selectedGridSize == size,
                      onTap: () => onSelected(size),
                    ),
                  ),
                );
              })
              .toList(growable: false),
        ),
      ],
    );
  }
}

class TrainingOptionSelector<T> extends StatelessWidget {
  const TrainingOptionSelector({
    required this.title,
    required this.choices,
    required this.selectedValue,
    required this.onSelected,
    super.key,
  });

  final String title;
  final List<TrainingChoice<T>> choices;
  final T selectedValue;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    final palette = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _SectionHeader(title: title),
        const SizedBox(height: AppSpacing.md),
        Container(
          decoration: BoxDecoration(
            color: palette.surfaceMuted,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          padding: const EdgeInsets.all(4),
          child: Row(
            children: choices
                .map((TrainingChoice<T> choice) {
                  return Expanded(
                    child: TrainingSegmentOptionCard(
                      label: choice.label,
                      caption: choice.caption,
                      isSelected: choice.value == selectedValue,
                      onTap: () => onSelected(choice.value),
                    ),
                  );
                })
                .toList(growable: false),
          ),
        ),
      ],
    );
  }
}

class TrainingSetupPrimaryButton extends StatelessWidget {
  const TrainingSetupPrimaryButton({
    required this.enabled,
    required this.onPressed,
    super.key,
  });

  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: enabled ? onPressed : null,
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(68),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
        child: Text(
          '开始训练',
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class TrainingValidationBanner extends StatelessWidget {
  const TrainingValidationBanner({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    final palette = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: palette.errorSoft,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: palette.errorBorder),
      ),
      child: Text(
        message,
        style: textTheme.bodyMedium?.copyWith(
          color: palette.errorForeground,
          height: 1.5,
        ),
      ),
    );
  }
}

class TrainingChoice<T> {
  const TrainingChoice({
    required this.value,
    required this.label,
    required this.caption,
  });

  final T value;
  final String label;
  final String caption;
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
