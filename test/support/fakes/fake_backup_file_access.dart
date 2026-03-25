import 'package:schulte_grid/data/services/backup_file_access.dart';

class FakeBackupFileAccess implements BackupFileAccess {
  FakeBackupFileAccess({this.savedPathResult, this.pickedFileResult});

  String? savedPathResult;
  PickedBackupFile? pickedFileResult;
  String? lastSavedFileName;
  String? lastSavedContents;

  @override
  Future<PickedBackupFile?> pickBackupFile() async {
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
