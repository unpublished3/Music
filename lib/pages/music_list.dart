// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:music/utils/find_music_directory.dart';
import 'package:path/path.dart';

class MusicList extends StatefulWidget {
  MusicList({super.key});

  @override
  State<MusicList> createState() => _MusicListState();
}

class _MusicListState extends State<MusicList> {
  List mp3Files = [];

  @override
  void initState() {
    super.initState();
    updateMp3();
  }

  Future<void> updateMp3() async {
    List files = await findMp3Files();
    setState(() {
      mp3Files = files;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: mp3Files.length,
        itemBuilder: ((context, index) =>
            Text(basename(mp3Files[index].path))));
  }
}
