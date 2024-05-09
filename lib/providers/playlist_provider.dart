import 'dart:io';

import 'package:flutter/material.dart';
import 'package:music/providers/player_provider.dart';
import 'package:music/providers/player_status_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlaylistProvider extends ChangeNotifier {
  final List<File> _playlist = [];
  final List<File> _shuffledPlaylist = [];
  String _current = "none";
  bool _mode = false;

  List<File> get playlist =>
      !_mode ? _playlist.toList() : _shuffledPlaylist.toList();
  bool get mode => _mode;

  void addFiles(context, List<File> files) async {
    PlayerProvider playerProvider = Provider.of(context, listen: false);

    if (_playlist.length != files.length) {
      _playlist.addAll(files);
      _shuffledPlaylist.addAll(files);
    }

    final prefs = await SharedPreferences.getInstance();
    _mode = prefs.getBool("shuffle") ?? false;
    if (_mode == true) playerProvider.audioPlayer.setShuffleModeEnabled(mode);

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
    final playerStatusProvider =
        Provider.of<PlayerStatusProvider>(context, listen: false);

    _current = path;
    playerStatusProvider.set(context, path);
    _storeCurrent(path);

    notifyListeners();
  }

  void _storeCurrent(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("storedPath", path);
  }

  String get current => _current;
}
