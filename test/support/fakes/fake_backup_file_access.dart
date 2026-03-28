import 'package:schulte_grid/data/services/backup_file_access.dart';

class FakeBackupFileAccess implements BackupFileAccess {
  FakeBackupFileAccess({
    this.savedPathResult,
    this.pickedFileResult,
    this.pickBackupFileError,
  });

  String? savedPathResult;
  PickedBackupFile? pickedFileResult;
  Object? pickBackupFileError;
  String? lastSavedFileName;
  String? lastSavedContents;

  @override
  Future<PickedBackupFile?> pickBackupFile() async {
    final error = pickBackupFileError;
    if (error != null) {
      throw error;
    }

    return pickedFileResult;
  }

  @override
  Future<String?> saveBackupText({
    required String suggestedFileName,
    required String contents,
  }) async {
    lastSavedFileName = suggestedFileName;
    lastSavedContents = contents;
    return savedPathResult;
  }
}
