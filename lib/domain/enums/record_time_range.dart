import '../../data/models/training_record.dart';

enum RecordTimeRange {
  last7Days(label: '7天', dayCount: 7),
  last30Days(label: '30天', dayCount: 30),
  last180Days(label: '180天', dayCount: 180),
  allTime(label: '所有时间');

  const RecordTimeRange({required this.label, this.dayCount});

  final String label;
  final int? dayCount;

  bool matches(TrainingRecord record, DateTime now) {
    final start = startTime(now);
    if (start == null) {
      return true;
    }

    return !record.completedAt.isBefore(start);
  }

  DateTime? startTime(DateTime now) {
    if (dayCount == null) {
      return null;
    }

    return now.subtract(Duration(days: dayCount!));
  }
}
