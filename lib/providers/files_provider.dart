import 'dart:io';

import 'package:flutter/material.dart';

class FilesProvider extends ChangeNotifier {
  List<File> musicFiles = [];

  void addFiles(List<File> files) {
    musicFiles.addAll(files);
    notifyListeners();
  }

  void addFile(File file) {
    musicFiles.add(file);
    notifyListeners();
  }
}
