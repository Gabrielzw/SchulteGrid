import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme/app_theme.dart';

part 'app_toast_card.dart';

enum AppToastStatus { success, sync, error }

class AppToastHandle {
  const AppToastHandle._(this._toastId);

  final int _toastId;

  void close() {
    AppToast.dismiss(_toastId);
  }

  Future<void> closeAndWait() {
    return AppToast.dismissAndWait(_toastId);
  }
}

class AppToast {
  static const Duration _successDuration = Duration(seconds: 4);
  static const Duration _errorDuration = Duration(seconds: 5);
  static const Duration _transitionDuration = Duration(milliseconds: 160);
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
  static final Map<int, Completer<void>> _dismissCompleters =
      <int, Completer<void>>{};

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
      isVisible: false,
    );

    _entries.value = List<_ToastEntry>.unmodifiable(<_ToastEntry>[
      ..._entries.value,
      entry,
    ]);
    if (duration != null) {
      _timers[toastId] = Timer(duration, () => dismiss(toastId));
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setEntryVisibility(toastId, isVisible: true);
    });

    return AppToastHandle._(toastId);
  }

  static void dismiss(int toastId) {
    _beginDismiss(toastId);
  }

  static Future<void> dismissAndWait(int toastId) {
    final bool shouldWait = _beginDismiss(toastId);
    if (!shouldWait) {
      return Future<void>.value();
    }

    final Completer<void> completer =
        _dismissCompleters[toastId] ?? Completer<void>()
          ..complete();
    return completer.future;
  }

  static void dismissAll() {
    for (final int toastId in _timers.keys.toList(growable: false)) {
      _cancelTimer(toastId);
    }
    for (final Completer<void> completer in _dismissCompleters.values) {
      if (!completer.isCompleted) {
        completer.complete();
      }
    }
    _dismissCompleters.clear();
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
                                  (_ToastEntry entry) => _ToastCard(
                                    key: ValueKey<int>(entry.id),
                                    entry: entry,
                                    onClose: () => dismiss(entry.id),
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

  static bool _beginDismiss(int toastId) {
    final _ToastEntry? entry = _findEntry(toastId);
    if (entry == null) {
      return false;
    }
    if (!entry.isVisible) {
      return _dismissCompleters.containsKey(toastId);
    }

    _cancelTimer(toastId);
    _setEntryVisibility(toastId, isVisible: false);
    _dismissCompleters.putIfAbsent(toastId, Completer<void>.new);
    _timers[toastId] = Timer(_transitionDuration, () => _removeEntry(toastId));
    return true;
  }

  static _ToastEntry? _findEntry(int toastId) {
    for (final _ToastEntry entry in _entries.value) {
      if (entry.id == toastId) {
        return entry;
      }
    }

    return null;
  }

  static void _setEntryVisibility(int toastId, {required bool isVisible}) {
    bool isUpdated = false;
    final List<_ToastEntry> entries = _entries.value
        .map((_ToastEntry entry) {
          if (entry.id != toastId) {
            return entry;
          }

          isUpdated = true;
          return entry.copyWith(isVisible: isVisible);
        })
        .toList(growable: false);
    if (!isUpdated) {
      return;
    }

    _entries.value = List<_ToastEntry>.unmodifiable(entries);
  }

  static void _removeEntry(int toastId) {
    _cancelTimer(toastId);
    final Completer<void>? completer = _dismissCompleters.remove(toastId);
    _entries.value = List<_ToastEntry>.unmodifiable(
      _entries.value
          .where((_ToastEntry entry) => entry.id != toastId)
          .toList(growable: false),
    );
    if (completer != null && !completer.isCompleted) {
      completer.complete();
    }
    if (_entries.value.isEmpty) {
      _removeOverlay();
    }
  }

  static OverlayState? _findOverlay() {
    final BuildContext? context = Get.context;
    if (context == null) {
      return null;
    }

    return Navigator.of(context, rootNavigator: true).overlay;
  }
}

class _ToastEntry {
  const _ToastEntry({
    required this.id,
    required this.title,
    required this.message,
    required this.status,
    required this.isVisible,
  });

  final int id;
  final String title;
  final String message;
  final AppToastStatus status;
  final bool isVisible;

  _ToastEntry copyWith({bool? isVisible}) {
    return _ToastEntry(
      id: id,
      title: title,
      message: message,
      status: status,
      isVisible: isVisible ?? this.isVisible,
    );
  }
}
