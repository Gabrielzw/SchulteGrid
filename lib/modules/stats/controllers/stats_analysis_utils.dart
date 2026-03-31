import 'dart:math';

import '../../../data/models/training_record.dart';
import '../../training/models/training_session_support.dart';

const String emptyDurationLabel = '--';

Duration? fastestDuration(List<TrainingRecord> records) {
  if (records.isEmpty) {
    return null;
  }

  final milliseconds = records
      .map((TrainingRecord record) => record.durationInMilliseconds)
      .reduce(min);
  return Duration(milliseconds: milliseconds);
}

Duration? averageDuration(List<TrainingRecord> records) {
  if (records.isEmpty) {
    return null;
  }

  return Duration(milliseconds: averageMilliseconds(records).round());
}

double averageMilliseconds(List<TrainingRecord> records) {
  final total = records.fold<int>(
    0,
    (int value, TrainingRecord record) =>
        value + record.durationInMilliseconds,
  );
  return total / records.length;
}

double averageErrors(List<TrainingRecord> records) {
  final total = records.fold<int>(
    0,
    (int value, TrainingRecord record) => value + record.errorCount,
  );
  return total / records.length;
}

double standardDeviationMilliseconds(
  List<TrainingRecord> records,
  double average,
) {
  final variance = records.fold<double>(
    0,
    (double value, TrainingRecord record) {
      final delta = record.durationInMilliseconds - average;
      return value + (delta * delta);
    },
  );
  return sqrt(variance / records.length);
}

double medianMilliseconds(List<TrainingRecord> records) {
  final sortedDurations = records
      .map((TrainingRecord record) => record.durationInMilliseconds)
      .toList(growable: false)
    ..sort();
  final middle = sortedDurations.length ~/ 2;

  if (sortedDurations.length.isOdd) {
    return sortedDurations[middle].toDouble();
  }

  return (sortedDurations[middle - 1] + sortedDurations[middle]) / 2;
}

double spreadMilliseconds(List<TrainingRecord> records) {
  final durations = records
      .map((TrainingRecord record) => record.durationInMilliseconds)
      .toList(growable: false);
  return (durations.reduce(max) - durations.reduce(min)).toDouble();
}

String formatDurationLabel(Duration? duration) {
  if (duration == null) {
    return emptyDurationLabel;
  }

  return formatTrainingDuration(duration);
}

String formatDurationFromMilliseconds(double milliseconds) {
  return formatDurationLabel(Duration(milliseconds: milliseconds.round()));
}

String formatDecimal(double value) {
  if (value == value.roundToDouble()) {
    return value.toStringAsFixed(0);
  }

  return value.toStringAsFixed(1);
}

String formatShortDate(DateTime value) {
  return '${value.month}/${value.day}';
}
