// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:music/pages/music_list.dart';
import 'package:music/providers/files_provider.dart';
import 'package:music/providers/metadata_provider.dart';
import 'package:music/providers/player_provider.dart';
import 'package:music/providers/player_status_provider.dart';
import 'package:music/providers/playlist_provider.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  Home({super.key, required this.directory});
  String directory;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int? currentIndex;
  bool skipped = false;

  @override
  void initState() {
    super.initState();

    final playlistProvider =
        Provider.of<PlaylistProvider>(context, listen: false);

    final playerProvider = Provider.of<PlayerProvider>(context, listen: false);

    final filesProvider = Provider.of<FilesProvider>(context, listen: false);

    playerProvider.audioPlayer.playbackEventStream.listen((event) {
      currentIndex ??= event.currentIndex;

      if (currentIndex == event.currentIndex)
      {
        skipped = false;
      }

      if (currentIndex != event.currentIndex &&
          currentIndex != null &&
          mounted) {
        if (!skipped) {
          int newIndex =
              playerProvider.audioPlayer.sequenceState?.currentIndex ?? 0;

          playlistProvider.setCurrent(
              context, filesProvider.musicFiles[newIndex].path);
          skipped = true;
          currentIndex = null;
        }
      }
    });
  }

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
            children: [
              Divider(
                height: 1,
                thickness: 1,
              ),
              Expanded(
                child: MusicList(
                  directory: widget.directory,
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
          backgroundImage: playerStatusProvider.albumArt.image,
        ),
      ),
    );
  }
}
