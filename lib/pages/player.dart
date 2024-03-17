// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, must_be_immutable, prefer_const_constructors_in_immutables

import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import 'dart:io';
import "package:audioplayers/audioplayers.dart";
import "package:flutter/widgets.dart";
import "package:music/providers/metadata_provider.dart";

import "package:music/utils/format_data.dart" as formatter;
import "package:provider/provider.dart";

class PlayerUI extends StatefulWidget {
  File file;
  final player = AudioPlayer();
  PlayerUI({super.key, required this.file});

  @override
  State<PlayerUI> createState() => _PlayerUIState();
}

class _PlayerUIState extends State<PlayerUI> {
  // final player = AudioPlayer();

  // Application State
  bool _isPlaying = false;
  Duration? current = Duration.zero;
  late Duration duration;
  late String trackName, artistName;
  late Image albumArt;
  double percentageComplete = 0;

  @override
  void initState() {
    super.initState();
    setUrl();

    RequiredMetadata? map =
        Provider.of<MetadataProvider>(context, listen: false)
            .metadataMap[widget.file.path];
    if (map != null) {
      artistName = map.artistName;
      trackName = map.trackName;
      albumArt = map.albumArt;
      duration = map.trackDuration;
    }

    widget.player.onPositionChanged.listen((newPostion) {
      if (mounted) {
        setState(() {
          current = newPostion;
          percentageComplete = getPercentageComplete(current, duration);
        });
      }
    });
  }

  void setUrl() async {
    await widget.player.setSourceDeviceFile(widget.file.path);
    playPause();
    if (mounted) {
      setState(() {
        _isPlaying = !_isPlaying;
      });
    }
  }

  void playPause() async {
    if (_isPlaying) {
      await widget.player.pause();
    } else {
      await widget.player.resume();
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
                decoration: BoxDecoration(
                    image: DecorationImage(image: albumArt.image)),
              ),

              Column(
                children: [Text(trackName), Text(artistName)],
              ),

              Column(
                children: [
                  Slider(
                    onChanged: (double value) async {
                      percentageComplete = value;
                      await widget.player.seek(
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
                  GestureDetector(
                      onTap: () {}, child: Icon(Icons.skip_previous)),
                  ElevatedButton(
                    onPressed: () {
                      playPause();
                      if (mounted) {
                        setState(() {
                          _isPlaying = !_isPlaying;
                        });
                      }
                    },
                    child: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                  ),
                  GestureDetector(onTap: () {}, child: Icon(Icons.skip_next))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
