// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:music/pages/music_list.dart';
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
            builder: (context, value, child) => ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => value.player,
                      ),
                    );
                  },
                  child: Icon(Icons.music_note),
                )));
  }
}
