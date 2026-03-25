import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class EmptyStateCard extends StatelessWidget {
  const EmptyStateCard({required this.title, required this.message, super.key});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final palette = context.appColors;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: palette.cardBackground,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: palette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.xs),
          Text(message, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
