import 'package:flutter/material.dart';

class PlayerPositionProvider extends ChangeNotifier {
  late Duration _current;
  late double _percentageComplete;
  late bool _isPlaying;
  late bool _repeat;

  Duration get current => _current;
  double get percentageComplete => _percentageComplete;
  bool get isPlaying => _isPlaying;
  bool get repeat => _repeat;

  void reset() {
    _current = Duration.zero;
    _percentageComplete = 0;
    _isPlaying = false;
    _repeat = false;
  }

  void changePosition(Duration newPostion, Duration duration) {
    _current = newPostion;
    _percentageComplete = _current.inSeconds / duration.inSeconds;
    notifyListeners();
  }

  void alterPlayStatus() {
    _isPlaying = !_isPlaying;
  }

  void alterRepetition() {
    _repeat = !_repeat;
  } 
}
