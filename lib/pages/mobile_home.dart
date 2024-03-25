// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:music/pages/music_list.dart';
import 'package:music/pages/player.dart';
import 'package:music/providers/metadata_provider.dart';
import 'package:music/providers/player_provider.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class MobileHome extends StatefulWidget {
  const MobileHome({super.key});

  @override
  State<MobileHome> createState() => _MobileHomeState();
}

class _MobileHomeState extends State<MobileHome> {
  final directory = "/storage/emulated/0/Download";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: MusicList(directory: directory,),
        floatingActionButton: Consumer<PlayerProvider>(
            builder: (context, value, child) =>
                value.player.file.path != "/storage/emulated/0"
                    ? FloatingImage(
                        player: value.player,
                      )
                    : Container()));
  }
}

class FloatingImage extends StatefulWidget {
  FloatingImage({super.key, required this.player});

  PlayerUI player;

  @override
  State<FloatingImage> createState() => _FloatingImageState();
}

class _FloatingImageState extends State<FloatingImage> {
  late Image albumArt;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    RequiredMetadata? map =
        Provider.of<MetadataProvider>(context, listen: false)
            .metadataMap[widget.player.file.path];
    if (map != null) {
      albumArt = map.albumArt;
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            PageTransition(
                child: widget.player, type: PageTransitionType.bottomToTop));
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
