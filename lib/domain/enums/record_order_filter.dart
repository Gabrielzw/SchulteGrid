import '../../data/models/training_record.dart';
import 'training_order.dart';

enum RecordOrderFilter {
  all(label: '全部'),
  ascending(label: '正序'),
  descending(label: '倒序');

  const RecordOrderFilter({required this.label});

  final String label;

  bool matches(TrainingRecord record) {
    switch (this) {
      case RecordOrderFilter.all:
        return true;
      case RecordOrderFilter.ascending:
        return record.order == TrainingOrder.ascending.storageValue;
      case RecordOrderFilter.descending:
        return record.order == TrainingOrder.descending.storageValue;
    }
  }
}
