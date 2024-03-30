import 'package:flutter/material.dart';
import 'package:music/pages/player.dart';

class PlayerProvider extends ChangeNotifier {
  PlayerUI _player =
      PlayerUI();
  PlayerUI get player => _player;

  void changePlayer({required PlayerUI newPlayer}) async {
    _player = newPlayer;
    notifyListeners();
  }
}
