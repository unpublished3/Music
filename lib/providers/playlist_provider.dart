import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';

class PlaylistProvider extends ChangeNotifier {
  final List<File> _playlist = [];
  final List<File> _shuffledPlaylist = [];
  bool _mode = false;

  List<File> get playlist => !_mode? _playlist: _shuffledPlaylist;

  void addFiles(List<File> files) {
    _playlist.addAll(files);
    _shuffledPlaylist.addAll(files);
    notifyListeners();
  }

  void unshuffle() {
    _mode = false;
  }

  void shuffle() {
    final random = Random();
    _playlist.shuffle(random);
    _mode = true;
  }
}
