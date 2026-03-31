import '../../data/models/training_record.dart';

const List<int> fallbackGridSizes = <int>[3, 4, 5, 6, 7];

List<int> buildGridSizeOptions(Iterable<TrainingRecord> records) {
  final options = <int>{
    ...fallbackGridSizes,
    ..._recordGridSizes(records),
  }.toList();
  options.sort();
  return options;
}

String formatGridSizeLabel(int? gridSize) {
  if (gridSize == null) {
    return '全部';
  }

  return '$gridSize × $gridSize';
}

bool matchesGridSize(TrainingRecord record, int? gridSize) {
  return gridSize == null || record.gridSize == gridSize;
}

Set<int> _recordGridSizes(Iterable<TrainingRecord> records) {
  return records.map((TrainingRecord record) => record.gridSize).toSet();
}
