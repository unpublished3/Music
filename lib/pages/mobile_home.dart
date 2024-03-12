import 'package:flutter/material.dart';
import 'package:music/pages/music_list.dart';
import 'package:music/pages/player.dart';

class MobileHome extends StatefulWidget {
  const MobileHome({super.key});

  @override
  State<MobileHome> createState() => _MobileHomeState();
}

class _MobileHomeState extends State<MobileHome> {
  PlayerUI? player;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MusicList(),
    );
  }
}
