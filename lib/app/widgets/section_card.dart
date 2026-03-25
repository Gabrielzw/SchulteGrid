import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class SectionCard extends StatelessWidget {
  const SectionCard({
    required this.title,
    required this.child,
    this.subtitle,
    super.key,
  });

  final String title;
  final String? subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final palette = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: palette.cardBackground.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: palette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: textTheme.titleLarge),
          if (subtitle != null) ...<Widget>[
            const SizedBox(height: AppSpacing.xs),
            Text(subtitle!, style: textTheme.bodyMedium),
          ],
          const SizedBox(height: AppSpacing.md),
          child,
        ],
      ),
    );
  }
}
