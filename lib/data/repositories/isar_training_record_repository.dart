import 'package:isar_community/isar.dart';

import '../models/training_record.dart';
import 'training_record_repository.dart';

class IsarTrainingRecordRepository implements TrainingRecordRepository {
  const IsarTrainingRecordRepository(this._isar);

  final Isar _isar;

  @override
  Future<List<TrainingRecord>> fetchAll() {
    return _isar.trainingRecords.where().sortByCompletedAtDesc().findAll();
  }

  @override
  Future<void> save(TrainingRecord record) {
    return _isar.writeTxn(() async {
      await _isar.trainingRecords.put(record);
    });
  }
}
