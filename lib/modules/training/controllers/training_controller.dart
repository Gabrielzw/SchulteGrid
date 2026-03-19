import 'dart:async';
import 'dart:math';

import 'package:get/get.dart';

import '../../../data/models/training_record.dart';
import '../../../data/repositories/training_record_repository.dart';
import '../../../domain/enums/training_session_status.dart';
import '../../../domain/models/training_config.dart';
import '../../../domain/models/training_preview_cell.dart';
import '../models/training_session_support.dart';

class TrainingController extends GetxController {
  TrainingController({
    required this.config,
    required TrainingRecordRepository recordRepository,
    Random? random,
    bool autostart = false,
    Duration timerTickInterval = const Duration(milliseconds: 100),
    Duration errorFlashDuration = const Duration(milliseconds: 420),
  }) : _random = random ?? Random(),
       _recordRepository = recordRepository,
       _timerTickInterval = timerTickInterval,
       _errorFlashDuration = errorFlashDuration {
    _initializeTraining();
    if (autostart) {
      _revealBoardAndStart();
    }
  }

  final TrainingConfig config;
  final Random _random;
  final TrainingRecordRepository _recordRepository;
  final Duration _timerTickInterval;
  final Duration _errorFlashDuration;

  final Rx<TrainingSessionStatus> sessionStatus =
      TrainingSessionStatus.ready.obs;
  final RxInt elapsedMilliseconds = 0.obs;
  final RxInt errorCount = 0.obs;
  final RxInt completedCount = 0.obs;
  final RxList<TrainingPreviewCell> cells = <TrainingPreviewCell>[].obs;

  final Stopwatch _stopwatch = Stopwatch();
  final Set<String> _completedLabels = <String>{};
  final RxnString _errorLabel = RxnString();
  final RxnString _lastCompletedLabel = RxnString();

  Timer? _ticker;
  Timer? _errorTimer;
  late final List<String> targetSequence;
  late final List<String> _orderedValues;
  late final Map<String, int> _targetOrderLookup;
  late List<String> _boardValues;

  String get sessionEyebrow {
    switch (sessionStatus.value) {
      case TrainingSessionStatus.ready:
        return '准备开始';
      case TrainingSessionStatus.running:
        return '专注训练';
      case TrainingSessionStatus.paused:
        return '训练已暂停';
      case TrainingSessionStatus.completed:
        return '本轮完成';
    }
  }

  String get sessionMetaLabel =>
      '${config.gridSize} × ${config.gridSize} ${config.mode.shortLabel} · ${config.orderLabel}';

  String get nextTargetLabel {
    if (completedCount.value >= targetSequence.length) {
      return '完成';
    }

    return targetSequence[completedCount.value];
  }

  String get displayNextTargetLabel => _formatDisplayLabel(nextTargetLabel);

  String get timerLabel =>
      formatTrainingDuration(Duration(milliseconds: elapsedMilliseconds.value));

  String get progressLabel => '${completedCount.value}/${config.totalCells}';

  double get progressValue => completedCount.value / config.totalCells;

  String get actionLabel => sessionStatus.value.actionLabel;

  bool get canInteract => sessionStatus.value == TrainingSessionStatus.running;

  bool get canTapBoard =>
      sessionStatus.value == TrainingSessionStatus.ready || canInteract;

  bool get isReady => sessionStatus.value == TrainingSessionStatus.ready;

  bool get isRunning => sessionStatus.value == TrainingSessionStatus.running;

  bool get isPaused => sessionStatus.value == TrainingSessionStatus.paused;

  bool get isCompleted =>
      sessionStatus.value == TrainingSessionStatus.completed;

  bool get isBoardRevealed => !isReady;

  String get primaryHint {
    switch (sessionStatus.value) {
      case TrainingSessionStatus.ready:
        return '先点任意格子显示数字，再开始计时。';
      case TrainingSessionStatus.running:
        return '数字已显示，按当前目标继续点击。';
      case TrainingSessionStatus.paused:
        return '点击继续训练后恢复计时和点击。';
      case TrainingSessionStatus.completed:
        return '本轮训练已完成，可以直接再来一局。';
    }
  }

  String get targetLabelTitle => '当前目标';

  int get accuracyValue {
    final attemptCount = completedCount.value + errorCount.value;
    if (attemptCount == 0) {
      return 100;
    }

    final accuracy = completedCount.value / attemptCount;
    return (accuracy * 100).round();
  }

  String get accuracyLabel => '$accuracyValue%';

  String get completionSummary =>
      '用时 $timerLabel · 准确率 $accuracyLabel · 错误 ${errorCount.value} 次';

  void handlePrimaryAction() {
    switch (sessionStatus.value) {
      case TrainingSessionStatus.ready:
        return;
      case TrainingSessionStatus.running:
        pauseSession();
        return;
      case TrainingSessionStatus.paused:
        resumeSession();
        return;
      case TrainingSessionStatus.completed:
        restartSession();
        return;
    }
  }

  void restartSession() {
    _prepareSession(reshuffleBoard: true);
  }

  void pauseSession() {
    if (!isRunning) {
      return;
    }

    _stopwatch.stop();
    _cancelTicker();
    sessionStatus.value = TrainingSessionStatus.paused;
  }

  void resumeSession() {
    if (!isPaused) {
      return;
    }

    _stopwatch.start();
    sessionStatus.value = TrainingSessionStatus.running;
    _startTicker();
  }

  void handleCellTap(String label) {
    if (isReady) {
      _revealBoardAndStart();
      return;
    }

    if (!canInteract || _completedLabels.contains(label)) {
      return;
    }

    if (label != nextTargetLabel) {
      _showErrorFeedback(label);
      return;
    }

    _completedLabels.add(label);
    _lastCompletedLabel.value = label;
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

  void _prepareSession({required bool reshuffleBoard}) {
    if (reshuffleBoard) {
      _boardValues = reshuffleBoardValues(_orderedValues, _random);
    }

    _cancelTimers();
    _stopwatch
      ..stop()
      ..reset();
    _completedLabels.clear();
    completedCount.value = 0;
    errorCount.value = 0;
    elapsedMilliseconds.value = 0;
    _errorLabel.value = null;
    _lastCompletedLabel.value = null;
    sessionStatus.value = TrainingSessionStatus.ready;
    _rebuildCells();
  }

  void _revealBoardAndStart() {
    _cancelTimers();
    _stopwatch
      ..reset()
      ..start();
    elapsedMilliseconds.value = 0;
    sessionStatus.value = TrainingSessionStatus.running;
    _rebuildCells();
    _startTicker();
  }

  void _finishTraining() {
    _stopwatch.stop();
    _cancelTicker();
    elapsedMilliseconds.value = _stopwatch.elapsedMilliseconds;
    sessionStatus.value = TrainingSessionStatus.completed;
    _rebuildCells();
    unawaited(_saveCompletedRecord());
  }

  Future<void> _saveCompletedRecord() async {
    try {
      await _recordRepository.save(_buildTrainingRecord());
    } catch (error, stackTrace) {
      Get.snackbar('记录保存失败', '$error', snackPosition: SnackPosition.BOTTOM);
      Zone.current.handleUncaughtError(error, stackTrace);
    }
  }

  TrainingRecord _buildTrainingRecord() {
    return TrainingRecord()
      ..mode = config.mode.storageValue
      ..order = config.order.storageValue
      ..gridSize = config.gridSize
      ..durationInMilliseconds = elapsedMilliseconds.value
      ..errorCount = errorCount.value
      ..completedAt = DateTime.now();
  }

  void _startTicker() {
    _cancelTicker();
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
    _cancelTicker();
    _cancelErrorTimer();
  }

  void _cancelTicker() {
    _ticker?.cancel();
    _ticker = null;
  }

  void _cancelErrorTimer() {
    _errorTimer?.cancel();
    _errorTimer = null;
  }

  void _rebuildCells() {
    cells.assignAll(
      buildTrainingCells(
        config: config,
        boardValues: _boardValues,
        targetOrderLookup: _targetOrderLookup,
        completedLabels: _completedLabels,
        errorLabel: _errorLabel.value,
        currentTargetLabel: null,
        recentCorrectLabel: _lastCompletedLabel.value,
        highlightCompletedTrail: isCompleted,
        revealLabels: isBoardRevealed,
      ),
    );
  }

  String _formatDisplayLabel(String label) {
    if (label == '完成') {
      return label;
    }

    return formatTrainingLabel(label);
  }
}
