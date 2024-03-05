// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, must_be_immutable, prefer_const_constructors_in_immutables

import "package:flutter/material.dart";
import "package:just_audio/just_audio.dart";

class PlayerUI extends StatefulWidget {
  PlayerUI({super.key});

  @override
  State<PlayerUI> createState() => _PlayerUIState();
}

class _PlayerUIState extends State<PlayerUI> {
  final player = AudioPlayer();
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    setUrl();
  }

  void setUrl() async {
    await player.setUrl('asset:///assets/file.mp3');
  }

  void playPause() async {
    if (_isPlaying) {
      await player.pause();
    } else {
      await player.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 150),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Music Image
          Container(
            height: MediaQuery.of(context).size.height * 0.35,
            width: MediaQuery.of(context).size.width,
            color: Colors.red,
          ),

          Column(
            children: [Text("Name"), Text("Artist")],
          ),

          Column(
            children: [
              Slider(
                onChanged: (double a) {},
                value: 0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text("Current Time"), Text("End Time")],
              )
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(Icons.skip_previous),
              ElevatedButton(
                onPressed: () {
                  playPause();
                  setState(() {
                    _isPlaying = !_isPlaying;
                  });
                },
                child: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
              ),
              Icon(Icons.skip_next)
            ],
          )
        ],
      ),
    );
  }
}
