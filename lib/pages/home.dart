// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:music/pages/music_list.dart';
import 'package:music/providers/metadata_provider.dart';
import 'package:music/providers/player_provider.dart';
import 'package:music/providers/player_status_provider.dart';
import 'package:music/providers/playlist_provider.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  Home({super.key, required this.directory});
  String directory;

  @override
  Widget build(BuildContext context) {
    // String current = Provider.of<PlaylistProvider>(context, listen: false).current;
    return Scaffold(
        body: MusicList(
          directory: directory,
        ),
        floatingActionButton: Consumer<PlaylistProvider>(
            builder: (context, value, child) => value.current != "none"
                ? FloatingImage(
                    current: value.current,
                  )
                : Container()));
  }
}

class FloatingImage extends StatelessWidget {
  FloatingImage({super.key, required this.current});

  String current;

  late Image albumArt;

  @override
  Widget build(BuildContext context) {
    RequiredMetadata? map =
        Provider.of<MetadataProvider>(context).metadataMap[current];
    final player = Provider.of<PlayerProvider>(context).player;
    PlayerStatusProvider playerStatusProvider =
        Provider.of<PlayerStatusProvider>(context);
    PlayerProvider playerProvider = Provider.of<PlayerProvider>(context);

    if (map != null) {
      albumArt = map.albumArt;
    }

    return GestureDetector(
      onTap: () {
        if (!playerStatusProvider.isPlaying) {
          playerStatusProvider.alterPlayStatus(playerProvider.audioPlayer);
        }
        Navigator.push(
            context,
            PageTransition(
                child: player, type: PageTransitionType.bottomToTop));
      },
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: CircleAvatar(
          backgroundImage: albumArt.image,
        ),
      ),
    );
  }
}
