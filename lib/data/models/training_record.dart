import 'package:isar_community/isar.dart';

part 'training_record.g.dart';

@collection
class TrainingRecord {
  Id id = Isar.autoIncrement;

  late String mode;
  late String order;
  late int gridSize;
  late int durationInMilliseconds;
  late int errorCount;
  late DateTime completedAt;
}
