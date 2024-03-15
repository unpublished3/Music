// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:music/pages/music_list.dart';
import 'package:music/pages/player.dart';
import 'package:music/providers/metadata_provider.dart';
import 'package:music/providers/player_provider.dart';
import 'package:provider/provider.dart';

class MobileHome extends StatefulWidget {
  const MobileHome({super.key});

  @override
  State<MobileHome> createState() => _MobileHomeState();
}

class _MobileHomeState extends State<MobileHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: MusicList(),
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

    RequiredMetadata? map =
        Provider.of<MetadataProvider>(context, listen: false)
            .metadataMap[widget.player.file.path];
    if (map != null) {
      albumArt = map.albumArt;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => widget.player,
            ),
          );
        },
        child: Icon(Icons.music_note));
  }
}
