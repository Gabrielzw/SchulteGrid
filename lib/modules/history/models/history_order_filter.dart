import '../../../data/models/training_record.dart';
import '../../../domain/enums/training_order.dart';

enum HistoryOrderFilter {
  all(label: '全部'),
  ascending(label: '正序'),
  descending(label: '倒序');

  const HistoryOrderFilter({required this.label});

  final String label;

  bool matches(TrainingRecord record) {
    switch (this) {
      case HistoryOrderFilter.all:
        return true;
      case HistoryOrderFilter.ascending:
        return record.order == TrainingOrder.ascending.storageValue;
      case HistoryOrderFilter.descending:
        return record.order == TrainingOrder.descending.storageValue;
    }
  }
}
