import 'package:flutter/material.dart';

class PlayerPositionProvider extends ChangeNotifier {
  Duration _current = Duration.zero;
  double _percentageComplete = 0;

  Duration get current => _current;
  double get percentageComplete => _percentageComplete;

  void changePosition(Duration newPostion, Duration duration) {
    _current = newPostion;
    _percentageComplete = _current.inSeconds / duration.inSeconds;
    notifyListeners();
  }
}
