import '../models/training_record.dart';

abstract interface class TrainingRecordRepository {
  Future<List<TrainingRecord>> fetchAll();

  Future<void> replaceAll(List<TrainingRecord> records);

  Future<void> save(TrainingRecord record);
}
