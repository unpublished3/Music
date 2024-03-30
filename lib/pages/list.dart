// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:music/pages/player.dart';
import 'package:music/providers/metadata_provider.dart';
import 'package:music/providers/player_status_provider.dart';
import 'package:music/providers/player_provider.dart';
import 'package:music/providers/playlist_provider.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path/path.dart';
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
      final playerStatusProvider =
          Provider.of<PlayerStatusProvider>(context, listen: false);
      playerStatusProvider.alterPlayStatus(playerProvider.player.player);
      return;
    }
    PlayerUI player = PlayerUI();
    playlistProvider.setCurrent(file.path);
    PlayerUI currentPlayer = playerProvider.player;
    currentPlayer.player.pause();

    Navigator.push(context,
        PageTransition(child: player, type: PageTransitionType.bottomToTop));
    playerProvider.changePlayer(newPlayer: player);
  }

  @override
  Widget build(BuildContext context) {
    String current =
        Provider.of<PlaylistProvider>(context, listen: false).current;

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
          return GestureDetector(
              onTap: () => {setPlayer(context)},
              child: ListElement(
                  current: current == file.path,
                  albumArt: requiredMetadata.albumArt,
                  trackName:
                      formatter.formatName(requiredMetadata.trackName, 30),
                  artistName: requiredMetadata.artistName,
                  trackDuration: formatter
                      .formatDuration(requiredMetadata.trackDuration)));
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
    return Padding(
      padding: const EdgeInsets.only(right: 20, left: 20, top: 15, bottom: 0),
      child: Container(
        padding: EdgeInsets.all(12),
        height: MediaQuery.of(context).size.height * 0.1,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(12),
          color: current ? Colors.grey[400] : Colors.white,
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
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
                  child: Column(
                    children: [Text(trackName), Text(artistName)],
                  ),
                )
              ],
            ),
            Text(trackDuration)
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
        width: MediaQuery.of(context).size.height * 0.07,
        decoration: BoxDecoration(
          image: DecorationImage(image: albumArt.image, fit: BoxFit.contain),
          borderRadius: BorderRadius.circular(100),
        ));
  }
}
