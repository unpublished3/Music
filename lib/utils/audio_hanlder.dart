import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioPlayerHandler extends BaseAudioHandler {
  final _player = AudioPlayer();

  Future<void> changePlayer(String filePath) => _player.setSourceDeviceFile(filePath);

  @override
  Future<void> play() => _player.resume();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> stop() => _player.stop();
}
