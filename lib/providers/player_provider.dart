import 'dart:io'; 
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:metadata_god/metadata_god.dart';
import 'package:music/pages/player.dart';
import 'package:music/providers/metadata_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class PlayerProvider extends ChangeNotifier {
  PlayerUI _player = PlayerUI();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final uuid = const Uuid();

  PlayerUI get player => _player;
  AudioPlayer get audioPlayer => _audioPlayer;

  void changePlayer({required PlayerUI newPlayer}) async {
    _player = newPlayer;
    notifyListeners();
  }

  void setUrl(context, {required String filePath}) async {
    RequiredMetadata? map =
        Provider.of<MetadataProvider>(context, listen: false)
            .metadataMap[filePath];
      final audioMetadata = await MetadataGod.readMetadata(file: filePath);
      Picture? picture = audioMetadata.picture;


    if (map != null && picture != null) {
      String imagePath =  await _createFile(picture);
      imagePath = "file://$imagePath";
      print("$imagePath\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n");

      await _audioPlayer.setAudioSource(AudioSource.uri(Uri.file(filePath),
          // ignore: prefer_const_constructors
          tag: MediaItem(
            id: uuid.v1(),
            title: map.trackName,
            album: map.artistName,
            artUri: Uri.parse(imagePath)),
          ));
    }

    await audioPlayer.play();
  }

  Future<String> _createFile(Picture albumArt) async {
    final tempDir = Directory.systemTemp;
    final image = albumArt.data;

    final File file = File("${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg");
    file.writeAsBytes(image);

    return file.path;
  }
}
