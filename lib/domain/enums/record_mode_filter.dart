import '../../data/models/training_record.dart';
import 'training_mode.dart';

enum RecordModeFilter {
  all(label: '全部'),
  numbers(label: '数字'),
  letters(label: '字母');

  const RecordModeFilter({required this.label});

  final String label;

  TrainingMode? get trainingMode {
    switch (this) {
      case RecordModeFilter.all:
        return null;
      case RecordModeFilter.numbers:
        return TrainingMode.numbers;
      case RecordModeFilter.letters:
        return TrainingMode.letters;
    }
  }

  bool matches(TrainingRecord record) {
    switch (this) {
      case RecordModeFilter.all:
        return true;
      case RecordModeFilter.numbers:
        return record.mode == TrainingMode.numbers.storageValue;
      case RecordModeFilter.letters:
        return record.mode == TrainingMode.letters.storageValue;
    }
  }
}
