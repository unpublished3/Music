// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:music/pages/player.dart';
import 'package:music/providers/metadata_provider.dart';
import 'package:music/providers/player_provider.dart';
import 'package:music/providers/playlist_provider.dart';
import 'package:page_transition/page_transition.dart';
import 'dart:io';
import 'package:provider/provider.dart';

import "package:music/utils/format_data.dart" as formatter;

class ListUI extends StatelessWidget {
  File file;

  ListUI({super.key, required this.file});

  late RequiredMetadata requiredMetadata;

  Future<void> getMetadata(context) async {
    RequiredMetadata? map =
        Provider.of<MetadataProvider>(context, listen: false)
            .metadataMap[file.path];
    if (map != null) {
      requiredMetadata = map;
    }
  }

  void setPlayer(context) {
    final playerProvider = Provider.of<PlayerProvider>(context, listen: false);

    final playlistProvider =
        Provider.of<PlaylistProvider>(context, listen: false);

    if (playlistProvider.current == file.path) {
      if (playerProvider.audioPlayer.playing) {
        playerProvider.audioPlayer.pause();
      } else {
        playerProvider.audioPlayer.play();
      }
      return;
    }

    PlayerUI player = PlayerUI();
    playerProvider.audioPlayer.pause();

    playlistProvider.setCurrent(context, file.path);

    Navigator.push(context,
        PageTransition(child: player, type: PageTransitionType.bottomToTop));
    playerProvider.changePlayer(newPlayer: player);
    playerProvider.setUrl(context, filePath: file.path);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: getMetadata(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while waiting for permission result
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Handle any errors
          return Scaffold(body: Center(child: Text('Error1 occurred')));
        } else {
          // Permission granted or denied
          return Selector<PlaylistProvider, String>(
            selector: (context, provider) => provider.current,
            builder: (context, currentMusic, child) => GestureDetector(
                onTap: () => {setPlayer(context)},
                child: ListElement(
                    current: currentMusic == file.path,
                    albumArt: requiredMetadata.albumArt,
                    trackName:
                        formatter.formatName(requiredMetadata.trackName, 30),
                    artistName: requiredMetadata.artistName,
                    trackDuration: formatter
                        .formatDuration(requiredMetadata.trackDuration))),
          );
        }
      },
    );
  }
}

class ListElement extends StatelessWidget {
  const ListElement({
    super.key,
    required this.albumArt,
    required this.trackName,
    required this.artistName,
    required this.trackDuration,
    required this.current,
  });

  final Image albumArt;
  final String trackName;
  final String artistName;
  final String trackDuration;
  final bool current;

  @override
  Widget build(BuildContext context) {
    bool isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    Color activeColor = isDark
        ? Color.fromARGB(223, 213, 131, 235)
        : Color.fromARGB(223, 102, 9, 127);

    return Padding(
      padding: const EdgeInsets.only(right: 20, left: 20, top: 8, bottom: 7),
      child: Container(
        padding: EdgeInsets.all(12),
        height: MediaQuery.of(context).size.height * 0.09,
        decoration: BoxDecoration(
          color: isDark
              ? Color.fromARGB(255, 40, 38, 38)
              : Color.fromARGB(255, 215, 213, 213),
          border: Border.all(
              color: current ? activeColor : Color.fromARGB(255, 155, 155, 155),
              width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                AlbumArt(albumArt: albumArt),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        trackName,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: current
                                ? activeColor
                                : Theme.of(context)
                                    .primaryTextTheme
                                    .bodyMedium
                                    ?.color),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        artistName,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: current
                                ? activeColor
                                : Theme.of(context)
                                    .primaryTextTheme
                                    .bodyMedium
                                    ?.color),
                      )
                    ],
                  ),
                )
              ],
            ),
            current
                ? Icon(Icons.equalizer, color: activeColor)
                : Text(trackDuration)
          ],
        ),
      ),
    );
  }
}

class AlbumArt extends StatelessWidget {
  const AlbumArt({
    super.key,
    required this.albumArt,
  });

  final Image albumArt;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.height * 0.06,
        decoration: BoxDecoration(
          image: DecorationImage(image: albumArt.image, fit: BoxFit.contain),
          borderRadius: BorderRadius.circular(8),
        ));
  }
}
