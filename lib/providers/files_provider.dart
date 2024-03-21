import 'dart:io';

import 'package:flutter/material.dart';

class FilesProvider extends ChangeNotifier {
  List<File> musicFiles = [];

  void addFiles(List<File> files) {
    if (musicFiles.length != files.length) {
      musicFiles.addAll(files);
    }
    notifyListeners();
  }

  void addFile(File file) {
    musicFiles.add(file);
    notifyListeners();
  }
}
