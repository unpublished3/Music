import 'dart:io';

import 'package:flutter/material.dart';

class FilesProvider extends ChangeNotifier {
  List<File> musicFiles = [];
  bool _searchActive = false;

  bool get searchActive => _searchActive;

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

  void alterSearch() {
    _searchActive = !_searchActive;
    notifyListeners();
  }
}
