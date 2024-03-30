import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music/pages/player.dart';

class PlayerProvider extends ChangeNotifier {
  PlayerUI _player =
      PlayerUI();
  final AudioPlayer _audioPlayer = AudioPlayer();

  PlayerUI get player => _player;
  AudioPlayer get audioPlayer => _audioPlayer;

  void changePlayer({required PlayerUI newPlayer}) async {
    _player = newPlayer;
    notifyListeners();
  }
}
