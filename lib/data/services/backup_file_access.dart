import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

abstract interface class BackupFileAccess {
  Future<String?> saveBackupText({
    required String suggestedFileName,
    required String contents,
  });

  Future<PickedBackupFile?> pickBackupFile();
}

class PickedBackupFile {
  const PickedBackupFile({required this.name, required this.contents});

  final String name;
  final String contents;
}

class FilePickerBackupFileAccess implements BackupFileAccess {
  FilePickerBackupFileAccess({FilePicker? picker})
    : _picker = picker ?? FilePicker.platform;

  static const List<String> _allowedExtensions = <String>['json'];
  static const String _exportDialogTitle = '选择备份文件导出位置';
  static const String _restoreDialogTitle = '选择要恢复的备份文件';

  final FilePicker _picker;

  @override
  Future<String?> saveBackupText({
    required String suggestedFileName,
    required String contents,
  }) {
    return _picker.saveFile(
      dialogTitle: _exportDialogTitle,
      fileName: suggestedFileName,
      type: FileType.custom,
      allowedExtensions: _allowedExtensions,
      bytes: Uint8List.fromList(utf8.encode(contents)),
    );
  }

  @override
  Future<PickedBackupFile?> pickBackupFile() async {
    final FilePickerResult? result = await _picker.pickFiles(
      dialogTitle: _restoreDialogTitle,
      type: FileType.custom,
      allowedExtensions: _allowedExtensions,
      allowMultiple: false,
      withData: true,
    );
    if (result == null || result.files.isEmpty) {
      return null;
    }

    final PlatformFile file = result.files.single;
    final List<int> bytes = file.bytes ?? await file.xFile.readAsBytes();
    return PickedBackupFile(name: file.name, contents: utf8.decode(bytes));
  }
}
