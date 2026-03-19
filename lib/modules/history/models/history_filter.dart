import '../../../data/models/training_record.dart';
import '../../../domain/enums/training_mode.dart';

enum HistoryFilter {
  all(label: '全部'),
  numbers(label: '数字'),
  letters(label: '字母');

  const HistoryFilter({required this.label});

  final String label;

  bool matches(TrainingRecord record) {
    switch (this) {
      case HistoryFilter.all:
        return true;
      case HistoryFilter.numbers:
        return record.mode == TrainingMode.numbers.storageValue;
      case HistoryFilter.letters:
        return record.mode == TrainingMode.letters.storageValue;
    }
  }
}
