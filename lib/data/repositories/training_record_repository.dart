import '../models/training_record.dart';

abstract interface class TrainingRecordRepository {
  Future<List<TrainingRecord>> fetchAll();

  Future<void> save(TrainingRecord record);
}
