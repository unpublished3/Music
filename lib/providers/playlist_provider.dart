import 'dart:io';

import 'package:flutter/material.dart';
import 'package:music/providers/player_provider.dart';
import 'package:music/providers/player_status_provider.dart';
import 'package:provider/provider.dart';

class PlaylistProvider extends ChangeNotifier {
  final List<File> _playlist = [];
  final List<File> _shuffledPlaylist = [];
  String _current = "none";
  bool _mode = false;

  List<File> get playlist =>
      !_mode ? _playlist.toList() : _shuffledPlaylist.toList();
  bool get mode => _mode;

  void addFiles(List<File> files) {
    if (_playlist.length != files.length) {
      _playlist.addAll(files);
      _shuffledPlaylist.addAll(files);
    }
    notifyListeners();
  }

  void shuffle(context) {
    PlayerProvider playerProvider = Provider.of(context, listen: false);
    if (_mode == false) {
      _mode = true;
    } else {
      _mode = false;
    }
    playerProvider.audioPlayer.setShuffleModeEnabled(mode);

    notifyListeners();
  }

  void setCurrent(context, String path) {
    final playerStatusProvider = Provider.of<PlayerStatusProvider>(context, listen: false);

    _current = path;
    playerStatusProvider.set(context, path);

    notifyListeners();
  }

  String get current => _current;
}
