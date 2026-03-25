part of 'app_toast.dart';

class _ToastCard extends StatelessWidget {
  const _ToastCard({required this.entry, required this.onClose, super.key});

  final _ToastEntry entry;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final _ToastAppearance appearance = _ToastAppearance.resolve(
      context: context,
      status: entry.status,
    );
    final TextTheme textTheme = Theme.of(context).textTheme;

    return TweenAnimationBuilder<double>(
      duration: AppToast._transitionDuration,
      curve: Curves.easeOutCubic,
      tween: Tween<double>(end: entry.isVisible ? 1 : 0),
      builder: (BuildContext context, double value, Widget? child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * -14),
            child: ClipRect(
              child: Align(
                alignment: Alignment.topCenter,
                heightFactor: value,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: child,
                ),
              ),
            ),
          ),
        );
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: appearance.cardColor,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: appearance.borderColor),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: appearance.shadowColor,
              blurRadius: 32,
              offset: const Offset(0, 18),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 18, 10, 18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _ToastBadge(appearance: appearance),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        entry.title,
                        style: textTheme.headlineSmall?.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: appearance.titleColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        entry.message,
                        style: textTheme.titleMedium?.copyWith(
                          color: appearance.messageColor,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                tooltip: '关闭提示',
                onPressed: onClose,
                icon: Icon(
                  Icons.close_rounded,
                  color: appearance.closeIconColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ToastBadge extends StatelessWidget {
  const _ToastBadge({required this.appearance});

  final _ToastAppearance appearance;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: appearance.badgeColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: SizedBox.square(
        dimension: 66,
        child: Center(
          child: Icon(appearance.icon, size: 34, color: appearance.iconColor),
        ),
      ),
    );
  }
}

class _ToastAppearance {
  const _ToastAppearance({
    required this.cardColor,
    required this.borderColor,
    required this.shadowColor,
    required this.badgeColor,
    required this.iconColor,
    required this.titleColor,
    required this.messageColor,
    required this.closeIconColor,
    required this.icon,
  });

  final Color cardColor;
  final Color borderColor;
  final Color shadowColor;
  final Color badgeColor;
  final Color iconColor;
  final Color titleColor;
  final Color messageColor;
  final Color closeIconColor;
  final IconData icon;

  factory _ToastAppearance.resolve({
    required BuildContext context,
    required AppToastStatus status,
  }) {
    final AppThemeColors palette = context.appColors;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final bool isLight = Theme.of(context).brightness == Brightness.light;
    final Color cardColor = isLight
        ? palette.cardBackground.withValues(alpha: 0.98)
        : palette.cardBackground.withValues(alpha: 0.96);
    final Color borderColor = palette.border.withValues(
      alpha: isLight ? 0.78 : 0.92,
    );
    // final Color shadowColor = palette.shadowColor.withValues(
    //   alpha: isLight ? 0.14 : 0.32,
    // );
    final Color shadowColor = Colors.transparent;

    return switch (status) {
      AppToastStatus.success => _ToastAppearance(
        cardColor: cardColor,
        borderColor: borderColor,
        shadowColor: shadowColor,
        badgeColor: colorScheme.primary.withValues(alpha: isLight ? 0.1 : 0.18),
        iconColor: colorScheme.primary,
        titleColor: palette.textPrimary,
        messageColor: palette.textSecondary,
        closeIconColor: palette.textSecondary.withValues(alpha: 0.72),
        icon: Icons.check_rounded,
      ),
      AppToastStatus.sync => _ToastAppearance(
        cardColor: cardColor,
        borderColor: borderColor,
        shadowColor: shadowColor,
        badgeColor: colorScheme.primary.withValues(alpha: isLight ? 0.1 : 0.18),
        iconColor: colorScheme.primary,
        titleColor: palette.textPrimary,
        messageColor: palette.textSecondary,
        closeIconColor: palette.textSecondary.withValues(alpha: 0.72),
        icon: Icons.sync_rounded,
      ),
      AppToastStatus.error => _ToastAppearance(
        cardColor: cardColor,
        borderColor: borderColor,
        shadowColor: shadowColor,
        badgeColor: palette.errorSoft,
        iconColor: palette.errorForeground,
        titleColor: palette.textPrimary,
        messageColor: palette.textSecondary,
        closeIconColor: palette.textSecondary.withValues(alpha: 0.72),
        icon: Icons.warning_amber_rounded,
      ),
    };
  }
}
