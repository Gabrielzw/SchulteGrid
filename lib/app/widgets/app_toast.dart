import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme/app_theme.dart';

enum AppToastStatus { success, sync, error }

class AppToastHandle {
  const AppToastHandle._(this._toastId);

  final int _toastId;

  void close() {
    AppToast.dismiss(_toastId);
  }
}

class AppToast {
  static const Duration _successDuration = Duration(seconds: 4);
  static const Duration _errorDuration = Duration(seconds: 5);
  static const EdgeInsets _viewportPadding = EdgeInsets.fromLTRB(
    AppSpacing.md,
    AppSpacing.sm,
    AppSpacing.md,
    0,
  );
  static const double _maxWidth = 560;

  static final ValueNotifier<List<_ToastEntry>> _entries =
      ValueNotifier<List<_ToastEntry>>(<_ToastEntry>[]);
  static final Map<int, Timer> _timers = <int, Timer>{};

  static OverlayEntry? _overlayEntry;
  static int _nextToastId = 0;

  static AppToastHandle showSuccess({
    required String title,
    required String message,
    Duration? duration = _successDuration,
  }) {
    return show(
      title: title,
      message: message,
      status: AppToastStatus.success,
      duration: duration,
    );
  }

  static AppToastHandle showSync({
    required String title,
    required String message,
    Duration? duration,
  }) {
    return show(
      title: title,
      message: message,
      status: AppToastStatus.sync,
      duration: duration,
    );
  }

  static AppToastHandle showError({
    required String title,
    required String message,
    Duration? duration = _errorDuration,
  }) {
    return show(
      title: title,
      message: message,
      status: AppToastStatus.error,
      duration: duration,
    );
  }

  static AppToastHandle show({
    required String title,
    required String message,
    required AppToastStatus status,
    Duration? duration,
  }) {
    _ensureOverlay();
    final int toastId = _nextToastId++;
    final _ToastEntry entry = _ToastEntry(
      id: toastId,
      title: title,
      message: message,
      status: status,
    );

    _entries.value = List<_ToastEntry>.unmodifiable(<_ToastEntry>[
      ..._entries.value,
      entry,
    ]);
    if (duration != null) {
      _timers[toastId] = Timer(duration, () => dismiss(toastId));
    }

    return AppToastHandle._(toastId);
  }

  static void dismiss(int toastId) {
    _cancelTimer(toastId);
    _entries.value = List<_ToastEntry>.unmodifiable(
      _entries.value
          .where((_ToastEntry entry) => entry.id != toastId)
          .toList(growable: false),
    );
    if (_entries.value.isEmpty) {
      _removeOverlay();
    }
  }

  static void dismissAll() {
    for (final int toastId in _timers.keys.toList(growable: false)) {
      _cancelTimer(toastId);
    }
    _entries.value = const <_ToastEntry>[];
    _removeOverlay();
  }

  static void _ensureOverlay() {
    if (_overlayEntry != null) {
      return;
    }

    final OverlayState? overlay =
        Get.key.currentState?.overlay ?? _findOverlay();
    if (overlay == null) {
      throw StateError('AppToast 需要在应用界面构建完成后调用。');
    }
    final OverlayEntry entry = OverlayEntry(
      builder: (BuildContext context) {
        return Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: _viewportPadding,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: _maxWidth),
                  child: ValueListenableBuilder<List<_ToastEntry>>(
                    valueListenable: _entries,
                    builder:
                        (
                          BuildContext context,
                          List<_ToastEntry> entries,
                          Widget? child,
                        ) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: entries
                                .map(
                                  (_ToastEntry entry) => Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: AppSpacing.md,
                                    ),
                                    child: _ToastCard(
                                      key: ValueKey<int>(entry.id),
                                      entry: entry,
                                      onClose: () => dismiss(entry.id),
                                    ),
                                  ),
                                )
                                .toList(growable: false),
                          );
                        },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    overlay.insert(entry);
    _overlayEntry = entry;
  }

  static void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  static void _cancelTimer(int toastId) {
    _timers.remove(toastId)?.cancel();
  }

  static OverlayState? _findOverlay() {
    final BuildContext? context = Get.context;
    if (context == null) {
      return null;
    }

    return Navigator.of(context, rootNavigator: true).overlay;
  }
}

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
      duration: const Duration(milliseconds: 220),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (BuildContext context, double value, Widget? child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * -18),
            child: child,
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
    final Color shadowColor = palette.shadowColor.withValues(
      alpha: isLight ? 0.14 : 0.32,
    );

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

class _ToastEntry {
  const _ToastEntry({
    required this.id,
    required this.title,
    required this.message,
    required this.status,
  });

  final int id;
  final String title;
  final String message;
  final AppToastStatus status;
}
