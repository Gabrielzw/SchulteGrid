import '../../../data/models/training_record.dart';
import '../../../domain/enums/training_mode.dart';

enum HistoryModeFilter {
  all(label: '全部'),
  numbers(label: '数字'),
  letters(label: '字母');

  const HistoryModeFilter({required this.label});

  final String label;

  bool matches(TrainingRecord record) {
    switch (this) {
      case HistoryModeFilter.all:
        return true;
      case HistoryModeFilter.numbers:
        return record.mode == TrainingMode.numbers.storageValue;
      case HistoryModeFilter.letters:
        return record.mode == TrainingMode.letters.storageValue;
    }
  }
}
