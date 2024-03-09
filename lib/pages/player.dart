// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, must_be_immutable, prefer_const_constructors_in_immutables

import "package:flutter/material.dart";
// import "package:just_audio/just_audio.dart";
import "package:audioplayers/audioplayers.dart";

class PlayerUI extends StatefulWidget {
  PlayerUI({super.key});

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
    // await player.setSourceUrl();
    await player.setSourceAsset('File.mp3');
  }

  void playPause() async {
    if (_isPlaying) {
      await player.pause();
    } else {
      await player.resume();
    }
  }

  String formatDuration(Duration? duration) {
    if (duration != null) {
      final minutes = duration.inMinutes;
      final seconds = duration.inSeconds % 60;
      return '$minutes:${seconds.toString().padLeft(2, '0')}';
    }
    return "0:00";
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
                onChanged: (double value) async {
                  percentageComplete = value;
                  await player
                      .seek(Duration(seconds: seekLocation(value, duration)));
                },
                value: percentageComplete,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(formatDuration(current)),
                  Text(formatDuration(duration))
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
    );
  }
}
