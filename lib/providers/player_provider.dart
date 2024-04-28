import 'dart:io';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:metadata_god/metadata_god.dart';
import 'package:music/pages/player.dart';
import 'package:music/providers/files_provider.dart';
import 'package:music/providers/metadata_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class PlayerProvider extends ChangeNotifier {
  PlayerUI _player = PlayerUI();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final _uuid = const Uuid();
  String? previousPath;

  PlayerUI get player => _player;
  AudioPlayer get audioPlayer => _audioPlayer;

  void changePlayer({required PlayerUI newPlayer}) async {
    _player = newPlayer;
    notifyListeners();
  }

  void setUrl(context, {required String filePath}) async {
    List<UriAudioSource> audioSourceList = [];

    FilesProvider filesProvider =
        Provider.of<FilesProvider>(context, listen: false);

    for (File file in filesProvider.musicFiles) {
      RequiredMetadata? map =
          Provider.of<MetadataProvider>(context, listen: false)
              .metadataMap[file.path];
      final audioMetadata = await MetadataGod.readMetadata(file: file.path);
      Picture? picture = audioMetadata.picture;

      if (map != null && picture != null) {
        String imagePath = await _createFile(picture);
        previousPath = imagePath;
        imagePath = "file://$imagePath";

        audioSourceList.add(AudioSource.uri(
          Uri.file(file.path),
          // ignore: prefer_const_constructors
          tag: MediaItem(
              id: _uuid.v1(),
              title: map.trackName,
              // album: map.artistName,
              artUri: Uri.parse(imagePath),
              artist: map.artistName),
        ));
      }
    }
    AudioSource playlist = ConcatenatingAudioSource(children: audioSourceList);
    int index = filesProvider.musicFiles
        .indexWhere((element) => element.path == filePath);


    await audioPlayer.setAudioSource(playlist, initialIndex: index);
    await audioPlayer.play();
  }

  Future<String> _createFile(Picture albumArt) async {
    final tempDir = Directory.systemTemp;
    final image = albumArt.data;

    final File file =
        File("${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg");
    file.writeAsBytes(image);

    return file.path;
  }
}
