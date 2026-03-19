import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';
import '../../../domain/enums/training_session_status.dart';

class TrainingSessionActionBar extends StatelessWidget {
  const TrainingSessionActionBar({
    required this.status,
    required this.primaryLabel,
    required this.onPrimaryAction,
    required this.onRestart,
    super.key,
  });

  final TrainingSessionStatus status;
  final String primaryLabel;
  final VoidCallback onPrimaryAction;
  final VoidCallback onRestart;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: _ActionButton(
            label: primaryLabel,
            icon: _resolvePrimaryIcon(status),
            isEmphasized: status != TrainingSessionStatus.running,
            onPressed: onPrimaryAction,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        _IconActionButton(onPressed: onRestart),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.isEmphasized,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final bool isEmphasized;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final foregroundColor = isEmphasized ? Colors.white : AppColors.textPrimary;
    final backgroundColor = isEmphasized
        ? AppColors.seed
        : const Color(0xFFDCE4EC);

    return SizedBox(
      height: 72,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: foregroundColor),
        label: Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: foregroundColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
      ),
    );
  }
}

class _IconActionButton extends StatelessWidget {
  const _IconActionButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      height: 72,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: const Color(0xFFEAEFF6),
          foregroundColor: AppColors.textPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          padding: EdgeInsets.zero,
        ),
        child: const Icon(Icons.refresh_rounded, size: 26),
      ),
    );
  }
}

IconData _resolvePrimaryIcon(TrainingSessionStatus status) {
  switch (status) {
    case TrainingSessionStatus.ready:
      return Icons.play_arrow_rounded;
    case TrainingSessionStatus.running:
      return Icons.pause_rounded;
    case TrainingSessionStatus.paused:
      return Icons.play_arrow_rounded;
    case TrainingSessionStatus.completed:
      return Icons.replay_rounded;
  }
}
