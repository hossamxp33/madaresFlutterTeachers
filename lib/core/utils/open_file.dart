
import 'package:flutter/material.dart';
import 'package:open_file_manager/open_file_manager.dart';


Future<void> openMyFile(String filePath, BuildContext context) async {
  try {
    await openFileManager(
      iosConfig: IosConfig(
        // Path is case-sensitive here.
        subFolderPath:filePath,
      ),
      androidConfig: AndroidConfig(
        folderType: FolderType.download,
      ),
    );

  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Could not open file: $e')),
    );
  }
}