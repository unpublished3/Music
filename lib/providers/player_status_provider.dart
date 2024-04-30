import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music/providers/metadata_provider.dart';
import 'package:provider/provider.dart';

class PlayerStatusProvider extends ChangeNotifier {
  late Duration _current;
  late double _percentageComplete;
  late bool _isPlaying;
  late bool _repeat;

  late Duration _duration;
  late String _trackName, _artistName;
  late Image _albumArt;

  Duration get current => _current;
  Duration get duration => _duration;
  String get trackName => _trackName;
  String get artistName => _artistName;
  Image get albumArt => _albumArt;
  double get percentageComplete => _percentageComplete;
  bool get isPlaying => _isPlaying;
  bool get repeat => _repeat;

  void set(context, String path) async {
    RequiredMetadata? map =
        Provider.of<MetadataProvider>(context, listen: false).metadataMap[path];

    _current = Duration.zero;
    _percentageComplete = 0;
    _isPlaying = true;
    _repeat = false;

    if (map != null) {
      _artistName = map.artistName;
      _trackName = map.trackName;
      _albumArt = map.albumArt;
      _duration = map.trackDuration;
    }
    notifyListeners();
  }

  void changePosition(Duration newPostion, Duration duration) {
    _current = newPostion;
    _percentageComplete = _current.inSeconds / duration.inSeconds;
    notifyListeners();
  }

  void alterPlayStatus(AudioPlayer player) async {
    _isPlaying = !_isPlaying;

    if (!isPlaying) {
      await player.pause();
    } else {
      await player.play();
    }

    notifyListeners();
  }

  void reflectPlayStatusChange(bool playing)
  {
    _isPlaying = playing;
  }

  void alterRepetition() {
    _repeat = !_repeat;
    notifyListeners();
  }
}
