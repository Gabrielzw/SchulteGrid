import 'dart:async';

import 'package:get/get.dart';

import '../../../data/models/training_record.dart';
import '../../../data/repositories/training_record_repository.dart';
import '../../../domain/enums/record_mode_filter.dart';
import '../../../domain/enums/record_order_filter.dart';
import '../../../domain/enums/record_time_range.dart';
import '../../../domain/enums/training_mode.dart';
import '../../../domain/models/training_record_filter_support.dart';
import '../models/stats_view_data.dart';
import 'stats_analysis_builder.dart';

typedef StatsNowProvider = DateTime Function();

class StatsController extends GetxController {
  StatsController({
    required TrainingRecordRepository repository,
    StatsNowProvider? nowProvider,
  }) : _repository = repository,
       _nowProvider = nowProvider ?? DateTime.now;

  final TrainingRecordRepository _repository;
  final StatsNowProvider _nowProvider;

  final Rx<RecordTimeRange> selectedTimeRange = RecordTimeRange.allTime.obs;
  final Rx<RecordModeFilter> selectedModeFilter = RecordModeFilter.all.obs;
  final RxnInt selectedGridSize = RxnInt();
  final Rx<RecordOrderFilter> selectedOrderFilter = RecordOrderFilter.all.obs;
  final RxBool isLoading = false.obs;
  final RxnString loadError = RxnString();
  final RxList<TrainingRecord> _records = <TrainingRecord>[].obs;

  @override
  void onInit() {
    super.onInit();
    unawaited(refreshRecords());
  }

  List<RecordTimeRange> get timeRangeFilters => RecordTimeRange.values;

  List<RecordModeFilter> get modeFilters => RecordModeFilter.values;

  List<RecordOrderFilter> get orderFilters => RecordOrderFilter.values;

  List<int> get gridSizeOptions => buildGridSizeOptions(_records);

  List<TrainingRecord> get filteredRecords {
    final now = _nowProvider();
    return _records
        .where((TrainingRecord record) => _matchesFilters(record, now))
        .toList(growable: false);
  }

  int get recordCount => filteredRecords.length;

  List<StatsSummaryMetricData> get summaryMetrics =>
      buildStatsSummaryMetrics(filteredRecords);

  List<StatsModeAnalysisData> get modeAnalyses =>
      buildStatsModeAnalyses(filteredRecords, modes: _visibleModes);

  List<TrainingMode> get _visibleModes {
    final selectedMode = selectedModeFilter.value.trainingMode;
    if (selectedMode != null) {
      return <TrainingMode>[selectedMode];
    }

    return TrainingMode.values;
  }

  String get emptyMessage {
    if (_records.isEmpty) {
      return '完成至少一局训练后，这里会自动汇总各训练模式的基础统计、趋势和稳定性。';
    }

    return '当前筛选条件下还没有成绩，调整模式、尺寸、顺序或时间范围后再查看。';
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

  void selectModeFilter(RecordModeFilter filter) {
    selectedModeFilter.value = filter;
  }

  void selectGridSize(int? gridSize) {
    selectedGridSize.value = gridSize;
  }

  void selectOrderFilter(RecordOrderFilter filter) {
    selectedOrderFilter.value = filter;
  }

  String gridSizeLabel(int? gridSize) {
    return formatGridSizeLabel(gridSize);
  }

  bool _matchesFilters(TrainingRecord record, DateTime now) {
    return selectedTimeRange.value.matches(record, now) &&
        selectedModeFilter.value.matches(record) &&
        matchesGridSize(record, selectedGridSize.value) &&
        selectedOrderFilter.value.matches(record);
  }
}
