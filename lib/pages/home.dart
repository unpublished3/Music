// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
    return Scaffold(
        appBar: AppBar(
          title:
              Padding(padding: EdgeInsets.only(left: 5), child: Text("Music")),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 20),
              child: GestureDetector(
                child: Icon(Icons.search),
              ),
            )
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [Divider(height: 1, thickness: 1,),
              Expanded(
                child: MusicList(
                  directory: directory,
                ),
              )
            ],
          ),
        ),
        floatingActionButton: Consumer<PlaylistProvider>(
            builder: (context, value, child) => value.current != "none"
                ? FloatingImage(
                    current: value.current,
                  )
                : Container()));
  }
}

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar();
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
