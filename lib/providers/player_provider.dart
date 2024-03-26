import 'dart:io';

import 'package:flutter/material.dart';
import 'package:music/pages/player.dart';

class PlayerProvider extends ChangeNotifier {
  PlayerUI _player =
      PlayerUI(file: File.fromUri(Uri.file("none")));
  PlayerUI get player => _player;

  void changePlayer({required PlayerUI newPlayer}) async {
    _player = newPlayer;
    notifyListeners();
  }
}
