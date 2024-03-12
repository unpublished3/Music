import 'package:flutter/material.dart';
import 'package:music/pages/player.dart';

class PlayerProvider extends ChangeNotifier {
  PlayerUI? player;

  void changePlayer({required PlayerUI newPlayer}) async {
    player = newPlayer;
    notifyListeners();
  }
}
