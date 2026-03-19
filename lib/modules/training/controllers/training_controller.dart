import 'dart:async';
import 'dart:math';

import 'package:get/get.dart';

import '../../../domain/enums/training_session_status.dart';
import '../../../domain/models/training_config.dart';
import '../../../domain/models/training_preview_cell.dart';
import '../models/training_session_support.dart';

class TrainingController extends GetxController {
  TrainingController({
    required this.config,
    Random? random,
    Duration timerTickInterval = const Duration(milliseconds: 100),
    Duration errorFlashDuration = const Duration(milliseconds: 420),
  }) : _random = random ?? Random(),
       _timerTickInterval = timerTickInterval,
       _errorFlashDuration = errorFlashDuration {
    _initializeTraining();
  }

  static const int _sequencePreviewCount = 6;

  final TrainingConfig config;
  final Random _random;
  final Duration _timerTickInterval;
  final Duration _errorFlashDuration;

  final Rx<TrainingSessionStatus> sessionStatus =
      TrainingSessionStatus.ready.obs;
  final RxBool showGuideLabels = true.obs;
  final RxInt elapsedMilliseconds = 0.obs;
  final RxInt errorCount = 0.obs;
  final RxInt completedCount = 0.obs;
  final RxList<TrainingPreviewCell> cells = <TrainingPreviewCell>[].obs;

  final Stopwatch _stopwatch = Stopwatch();
  final Set<String> _completedLabels = <String>{};
  final RxnString _errorLabel = RxnString();

  Timer? _ticker;
  Timer? _errorTimer;
  late final List<String> targetSequence;
  late final List<String> _orderedValues;
  late final Map<String, int> _targetOrderLookup;
  late List<String> _boardValues;

  String get title =>
      '${config.gridSize} x ${config.gridSize} ${config.mode.shortLabel}训练';

  String get nextTargetLabel {
    if (completedCount.value >= targetSequence.length) {
      return '完成';
    }

    return targetSequence[completedCount.value];
  }

  String get targetSequencePreview {
    final previewValues = targetSequence
        .take(_sequencePreviewCount)
        .join(' -> ');
    if (targetSequence.length <= _sequencePreviewCount) {
      return previewValues;
    }

    return '$previewValues -> ... -> ${targetSequence.last}';
  }

  String get timerLabel =>
      _formatDuration(Duration(milliseconds: elapsedMilliseconds.value));

  String get progressLabel => '${completedCount.value}/${config.totalCells}';

  String get statusLabel => sessionStatus.value.label;

  String get actionLabel => sessionStatus.value.actionLabel;

  bool get canInteract => sessionStatus.value == TrainingSessionStatus.running;

  bool get isCompleted =>
      sessionStatus.value == TrainingSessionStatus.completed;

  String get statusDescription {
    switch (sessionStatus.value) {
      case TrainingSessionStatus.ready:
        return '点击开始训练后启动计时。';
      case TrainingSessionStatus.running:
        return '请按正确顺序持续点击，计时进行中。';
      case TrainingSessionStatus.completed:
        return '本轮训练已完成，计时已停止。';
    }
  }

  String get boardSubtitle {
    switch (sessionStatus.value) {
      case TrainingSessionStatus.ready:
        return '点击开始训练后启用点击校验与计时。';
      case TrainingSessionStatus.running:
        return '方格已随机打乱，点击正确目标会推进训练进度。';
      case TrainingSessionStatus.completed:
        return '本轮训练已结束，可以查看结果或重新开始。';
    }
  }

  String get resultSummary => '完成用时 $timerLabel，错误 ${errorCount.value} 次。';

  void setGuideLabels(bool value) {
    showGuideLabels.value = value;
  }

  void handlePrimaryAction() {
    switch (sessionStatus.value) {
      case TrainingSessionStatus.ready:
        _startSession(reshuffleBoard: false);
        return;
      case TrainingSessionStatus.running:
        _startSession(reshuffleBoard: true);
        return;
      case TrainingSessionStatus.completed:
        _startSession(reshuffleBoard: true);
        return;
    }
  }

  void handleCellTap(String label) {
    if (!canInteract || _completedLabels.contains(label)) {
      return;
    }

    if (label != nextTargetLabel) {
      _showErrorFeedback(label);
      return;
    }

    _completedLabels.add(label);
    completedCount.value = _completedLabels.length;
    _clearErrorFeedback();
    _rebuildCells();

    if (completedCount.value == targetSequence.length) {
      _finishTraining();
    }
  }

  @override
  void onClose() {
    _cancelTimers();
    super.onClose();
  }

  void _initializeTraining() {
    final boardSnapshot = buildTrainingBoardSnapshot(
      config: config,
      random: _random,
    );
    _orderedValues = boardSnapshot.orderedValues;
    _boardValues = boardSnapshot.boardValues;
    targetSequence = boardSnapshot.targetSequence;
    _targetOrderLookup = boardSnapshot.targetOrderLookup;
    _rebuildCells();
  }

  void _startSession({required bool reshuffleBoard}) {
    if (reshuffleBoard) {
      _boardValues = reshuffleBoardValues(_orderedValues, _random);
    }

    _cancelTimers();
    _stopwatch
      ..reset()
      ..start();
    _completedLabels.clear();
    completedCount.value = 0;
    errorCount.value = 0;
    elapsedMilliseconds.value = 0;
    _errorLabel.value = null;
    sessionStatus.value = TrainingSessionStatus.running;
    _rebuildCells();
    _startTicker();
  }

  void _finishTraining() {
    _stopwatch.stop();
    _ticker?.cancel();
    elapsedMilliseconds.value = _stopwatch.elapsedMilliseconds;
    sessionStatus.value = TrainingSessionStatus.completed;
    _rebuildCells();
  }

  void _startTicker() {
    _ticker = Timer.periodic(_timerTickInterval, (_) {
      elapsedMilliseconds.value = _stopwatch.elapsedMilliseconds;
    });
  }

  void _showErrorFeedback(String label) {
    errorCount.value++;
    _errorLabel.value = label;
    _rebuildCells();

    _errorTimer?.cancel();
    _errorTimer = Timer(_errorFlashDuration, _clearErrorFeedback);
  }

  void _clearErrorFeedback() {
    if (_errorLabel.value == null) {
      return;
    }

    _errorLabel.value = null;
    _rebuildCells();
  }

  void _cancelTimers() {
    _ticker?.cancel();
    _errorTimer?.cancel();
  }

  void _rebuildCells() {
    cells.assignAll(
      buildTrainingCells(
        boardValues: _boardValues,
        targetOrderLookup: _targetOrderLookup,
        completedLabels: _completedLabels,
        errorLabel: _errorLabel.value,
      ),
    );
  }

  String _formatDuration(Duration duration) {
    return formatTrainingDuration(duration);
  }
}
