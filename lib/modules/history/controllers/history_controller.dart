import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/training_record.dart';
import '../../../data/repositories/training_record_repository.dart';
import '../../../domain/enums/training_mode.dart';
import '../../../domain/enums/training_order.dart';
import '../../training/models/training_session_support.dart';
import '../models/history_filter.dart';
import '../models/history_record_view_data.dart';

class HistoryController extends GetxController {
  HistoryController({required TrainingRecordRepository repository})
    : _repository = repository;

  static const String _emptyDurationLabel = '--';

  final TrainingRecordRepository _repository;

  final Rx<HistoryFilter> selectedFilter = HistoryFilter.all.obs;
  final RxBool isLoading = false.obs;
  final RxnString loadError = RxnString();
  final RxList<TrainingRecord> _records = <TrainingRecord>[].obs;

  @override
  void onInit() {
    super.onInit();
    unawaited(refreshRecords());
  }

  List<HistoryFilter> get filters => HistoryFilter.values;

  List<TrainingRecord> get filteredRecords {
    return _records.where(selectedFilter.value.matches).toList(growable: false);
  }

  List<HistorySummaryMetricData> get summaryMetrics {
    return <HistorySummaryMetricData>[
      HistorySummaryMetricData(
        label: '训练次数',
        value: '$recordCount',
        caption: '当前筛选范围',
        icon: Icons.layers_outlined,
      ),
      HistorySummaryMetricData(
        label: '最佳成绩',
        value: bestDurationLabel,
        caption: recordCount == 0 ? '等待首条记录' : '用时最短的一局',
        icon: Icons.bolt_rounded,
      ),
      HistorySummaryMetricData(
        label: '最近完成',
        value: latestCompletionValueLabel,
        caption: latestCompletionCaptionLabel,
        icon: Icons.schedule_rounded,
      ),
    ];
  }

  List<HistoryRecordViewData> get visibleRecords {
    return filteredRecords.map(_buildRecordViewData).toList(growable: false);
  }

  int get recordCount => filteredRecords.length;

  String get bestDurationLabel {
    if (recordCount == 0) {
      return _emptyDurationLabel;
    }

    final duration = filteredRecords
        .map((TrainingRecord record) => record.durationInMilliseconds)
        .reduce(min);
    return formatTrainingDuration(Duration(milliseconds: duration));
  }

  String get latestCompletionValueLabel {
    if (recordCount == 0) {
      return '--/--';
    }

    final latest = filteredRecords.first.completedAt;
    return '${_twoDigits(latest.month)}/${_twoDigits(latest.day)}';
  }

  String get latestCompletionCaptionLabel {
    if (recordCount == 0) {
      return '等待首条记录';
    }

    final latest = filteredRecords.first;
    final mode = TrainingMode.fromStorageValue(latest.mode);
    return '${_formatTime(latest.completedAt)} · ${mode.shortLabel}';
  }

  String get recordsSectionTitle {
    return recordCount == 0 ? '历史记录' : '历史记录 · $recordCount 条';
  }

  String get recordsSectionSubtitle {
    return '按完成时间倒序排列，保留模式、尺寸、用时和错误次数。';
  }

  String get emptyMessage {
    if (selectedFilter.value == HistoryFilter.all) {
      return '完成训练后，这里会按时间倒序保留每一条成绩。';
    }

    return '当前筛选条件下还没有记录，切换模式或完成对应训练后再看。';
  }

  Future<void> refreshRecords() async {
    isLoading.value = true;
    loadError.value = null;
    try {
      final records = await _repository.fetchAll();
      _records.assignAll(records);
    } catch (error) {
      _records.clear();
      loadError.value = '读取历史记录失败：$error';
    } finally {
      isLoading.value = false;
    }
  }

  void selectFilter(HistoryFilter filter) {
    selectedFilter.value = filter;
  }

  HistoryRecordViewData _buildRecordViewData(TrainingRecord record) {
    final mode = TrainingMode.fromStorageValue(record.mode);
    final order = TrainingOrder.fromStorageValue(record.order);

    return HistoryRecordViewData(
      modeLabel: mode.shortLabel,
      orderLabel: order.label,
      gridLabel: '${record.gridSize} × ${record.gridSize}',
      durationLabel: formatTrainingDuration(
        Duration(milliseconds: record.durationInMilliseconds),
      ),
      completedAtLabel: _formatTimestamp(record.completedAt),
      accuracyLabel: '${_calculateAccuracy(record)}%',
      errorLabel: '错误 ${record.errorCount} 次',
      icon: mode.icon,
      tone: mode.tone,
    );
  }

  int _calculateAccuracy(TrainingRecord record) {
    final totalCells = record.gridSize * record.gridSize;
    final attemptCount = totalCells + record.errorCount;
    final accuracy = totalCells / attemptCount;
    return (accuracy * 100).round();
  }

  String _formatTimestamp(DateTime value) {
    final date =
        '${value.year}/${_twoDigits(value.month)}/${_twoDigits(value.day)}';
    return '$date ${_formatTime(value)}';
  }

  String _formatTime(DateTime value) {
    return '${_twoDigits(value.hour)}:${_twoDigits(value.minute)}';
  }

  String _twoDigits(int value) {
    return value.toString().padLeft(2, '0');
  }
}
