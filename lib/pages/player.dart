// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, must_be_immutable, prefer_const_constructors_in_immutables

import "package:flutter/material.dart";
import 'dart:io';
import "package:audioplayers/audioplayers.dart";

import "package:music/utils/format_data.dart" as formatter;

class PlayerUI extends StatefulWidget {
  File file;
  PlayerUI({super.key, required this.file});

  @override
  State<PlayerUI> createState() => _PlayerUIState();
}

class _PlayerUIState extends State<PlayerUI> {
  // final player = AudioPlayer();
  final player = AudioPlayer();

  // Application State
  bool _isPlaying = false;
  Duration? current = Duration.zero, duration;
  double percentageComplete = 0;

  @override
  void initState() {
    super.initState();
    setUrl();

    player.onPositionChanged.listen((newPostion) {
      setState(() {
        current = newPostion;
        percentageComplete = getPercentageComplete(current, duration);
      });
    });

    player.onDurationChanged.listen((newDuration) {
      duration = newDuration;
    });
  }

  void setUrl() async {
    await player.setSourceDeviceFile(widget.file.path);
    playPause();
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void playPause() async {
    if (_isPlaying) {
      await player.pause();
    } else {
      await player.resume();
    }
  }

  double getPercentageComplete(Duration? current, Duration? duration) {
    if (duration != null && current != null) {
      if (duration.inSeconds == 0) {
        return 0;
      }

      return (current.inSeconds / duration.inSeconds);
    }
    return 0;
  }

  int seekLocation(double value, Duration? duration) {
    if (duration != null) {
      return (value * duration.inSeconds).toInt();
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Padding(
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
                    onChanged: (double value) async {
                      percentageComplete = value;
                      await player.seek(
                          Duration(seconds: seekLocation(value, duration)));
                    },
                    value: percentageComplete,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(formatter.formatDuration(current)),
                      Text(formatter.formatDuration(duration))
                    ],
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
        ),
      ),
    );
  }
}
