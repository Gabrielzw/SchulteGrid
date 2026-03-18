import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class MetricTile extends StatelessWidget {
  const MetricTile({
    required this.label,
    required this.value,
    required this.icon,
    this.caption,
    super.key,
  });

  final String label;
  final String value;
  final String? caption;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      constraints: const BoxConstraints(minWidth: 156),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: AppSpacing.sm),
          Text(value, style: textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.xs),
          Text(label, style: textTheme.titleSmall),
          if (caption != null) ...<Widget>[
            const SizedBox(height: AppSpacing.xs),
            Text(caption!, style: textTheme.bodySmall),
          ],
        ],
      ),
    );
  }
}
