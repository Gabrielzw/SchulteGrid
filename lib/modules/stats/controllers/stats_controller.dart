import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/training_record.dart';
import '../../../data/repositories/training_record_repository.dart';
import '../../../domain/enums/record_time_range.dart';
import '../../../domain/enums/training_mode.dart';
import '../../../domain/enums/training_order.dart';
import '../../training/models/training_session_support.dart';
import '../models/stats_view_data.dart';

typedef StatsNowProvider = DateTime Function();

class StatsController extends GetxController {
  StatsController({
    required TrainingRecordRepository repository,
    StatsNowProvider? nowProvider,
  }) : _repository = repository,
       _nowProvider = nowProvider ?? DateTime.now;

  static const String _emptyDurationLabel = '--';

  final TrainingRecordRepository _repository;
  final StatsNowProvider _nowProvider;

  final Rx<RecordTimeRange> selectedTimeRange = RecordTimeRange.allTime.obs;
  final RxBool isLoading = false.obs;
  final RxnString loadError = RxnString();
  final RxList<TrainingRecord> _records = <TrainingRecord>[].obs;

  @override
  void onInit() {
    super.onInit();
    unawaited(refreshRecords());
  }

  List<RecordTimeRange> get timeRangeFilters => RecordTimeRange.values;

  List<TrainingRecord> get filteredRecords {
    final now = _nowProvider();
    return _records
        .where(
          (TrainingRecord record) =>
              selectedTimeRange.value.matches(record, now),
        )
        .toList(growable: false);
  }

  int get recordCount => filteredRecords.length;

  List<StatsSummaryMetricData> get summaryMetrics {
    final records = filteredRecords;
    final count = records.length;
    final bestDuration = _formatDuration(_fastestDuration(records));
    final averageDuration = _formatDuration(_averageDuration(records));

    return <StatsSummaryMetricData>[
      StatsSummaryMetricData(
        label: '最佳成绩',
        value: bestDuration,
        caption: count == 0 ? '当前范围还没有成绩' : '筛选范围内用时最短的一局',
        icon: Icons.workspace_premium_outlined,
      ),
      StatsSummaryMetricData(
        label: '平均用时',
        value: averageDuration,
        caption: count == 0 ? '暂无可计算成绩' : '已汇总 $count 次完成记录',
        icon: Icons.timer_outlined,
      ),
      StatsSummaryMetricData(
        label: '训练总次数',
        value: '$count',
        caption: count == 0 ? '完成首轮训练后自动更新' : '本地记录实时读取',
        icon: Icons.repeat_rounded,
      ),
    ];
  }

  StatsSessionHighlightData? get bestRecordHighlight {
    final bestRecord = _pickBestRecord(filteredRecords);
    if (bestRecord == null) {
      return null;
    }

    return _buildHighlightData(
      record: bestRecord,
      title: '最佳一局',
      caption: '当前时间范围内完成速度最快的一局训练。',
    );
  }

  StatsSessionHighlightData? get latestRecordHighlight {
    final records = filteredRecords;
    if (records.isEmpty) {
      return null;
    }

    return _buildHighlightData(
      record: records.first,
      title: '最近完成',
      caption: '最近一次保存到本地的训练成绩。',
    );
  }

  List<StatsModeInsightData> get modeInsights {
    final records = filteredRecords;
    return TrainingMode.values
        .map(
          (TrainingMode mode) => _buildModeInsight(
            mode: mode,
            records: _recordsForMode(records, mode),
          ),
        )
        .toList(growable: false);
  }

  String get emptyMessage {
    if (_records.isEmpty) {
      return '完成至少一局训练后，这里会自动汇总最佳成绩、平均用时和模式表现。';
    }

    return '当前时间范围内还没有成绩，切换时间范围后再查看。';
  }

  Future<void> refreshRecords() async {
    isLoading.value = true;
    loadError.value = null;
    try {
      final records = await _repository.fetchAll();
      _records.assignAll(records);
    } catch (error) {
      _records.clear();
      loadError.value = '读取训练成绩失败：$error';
    } finally {
      isLoading.value = false;
    }
  }

  void selectTimeRange(RecordTimeRange range) {
    selectedTimeRange.value = range;
  }

  StatsModeInsightData _buildModeInsight({
    required TrainingMode mode,
    required List<TrainingRecord> records,
  }) {
    final description = records.isEmpty ? '当前时间范围暂无完成记录。' : mode.description;
    return StatsModeInsightData(
      label: mode.shortLabel,
      description: description,
      sessionCountLabel: '${records.length} 次训练',
      bestDurationLabel: _formatDuration(_fastestDuration(records)),
      averageDurationLabel: _formatDuration(_averageDuration(records)),
      icon: mode.icon,
      tone: mode.tone,
    );
  }

  StatsSessionHighlightData _buildHighlightData({
    required TrainingRecord record,
    required String title,
    required String caption,
  }) {
    final mode = TrainingMode.fromStorageValue(record.mode);
    final order = TrainingOrder.fromStorageValue(record.order);

    return StatsSessionHighlightData(
      title: title,
      caption: caption,
      badgeLabel: mode.shortLabel,
      durationLabel: formatTrainingDuration(
        Duration(milliseconds: record.durationInMilliseconds),
      ),
      metaLabel: '${order.label} · ${record.gridSize} × ${record.gridSize}',
      completedAtLabel: _formatTimestamp(record.completedAt),
      primaryChipLabel: '准确率 ${_calculateAccuracy(record)}%',
      secondaryChipLabel: '错误 ${record.errorCount} 次',
      icon: mode.icon,
      tone: mode.tone,
    );
  }

  Duration? _fastestDuration(List<TrainingRecord> records) {
    if (records.isEmpty) {
      return null;
    }

    final fastest = records
        .map((TrainingRecord record) => record.durationInMilliseconds)
        .reduce(min);
    return Duration(milliseconds: fastest);
  }

  Duration? _averageDuration(List<TrainingRecord> records) {
    if (records.isEmpty) {
      return null;
    }

    final total = records.fold<int>(
      0,
      (int value, TrainingRecord record) =>
          value + record.durationInMilliseconds,
    );
    return Duration(milliseconds: (total / records.length).round());
  }

  TrainingRecord? _pickBestRecord(List<TrainingRecord> records) {
    if (records.isEmpty) {
      return null;
    }

    return records.reduce((TrainingRecord left, TrainingRecord right) {
      if (left.durationInMilliseconds != right.durationInMilliseconds) {
        return left.durationInMilliseconds < right.durationInMilliseconds
            ? left
            : right;
      }

      return left.completedAt.isAfter(right.completedAt) ? left : right;
    });
  }

  List<TrainingRecord> _recordsForMode(
    List<TrainingRecord> records,
    TrainingMode mode,
  ) {
    return records
        .where((TrainingRecord record) => record.mode == mode.storageValue)
        .toList(growable: false);
  }

  int _calculateAccuracy(TrainingRecord record) {
    final totalCells = record.gridSize * record.gridSize;
    final attemptCount = totalCells + record.errorCount;
    final accuracy = totalCells / attemptCount;
    return (accuracy * 100).round();
  }

  String _formatDuration(Duration? duration) {
    if (duration == null) {
      return _emptyDurationLabel;
    }

    return formatTrainingDuration(duration);
  }

  String _formatTimestamp(DateTime value) {
    final date =
        '${value.year}/${_twoDigits(value.month)}/${_twoDigits(value.day)}';
    return '$date ${_twoDigits(value.hour)}:${_twoDigits(value.minute)}';
  }

  String _twoDigits(int value) {
    return value.toString().padLeft(2, '0');
  }
}
