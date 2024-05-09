// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, must_be_immutable, prefer_const_constructors_in_immutables

import "dart:async";
import "dart:math";
import "dart:ui";

import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:just_audio/just_audio.dart";
import 'dart:io';
import "package:music/providers/player_status_provider.dart";
import "package:music/providers/player_provider.dart";
import "package:music/providers/playlist_provider.dart";

import "package:music/utils/format_data.dart" as formatter;
import "package:music/utils/metadata.dart";
import "package:page_transition/page_transition.dart";
import "package:provider/provider.dart";
import "package:shared_preferences/shared_preferences.dart";

class PlayerUI extends StatefulWidget {
  PlayerUI({super.key});

  @override
  State<PlayerUI> createState() => _PlayerUIState();
}

class _PlayerUIState extends State<PlayerUI> {
  late PlayerStatusProvider playerStatusProvider;
  late PlayerProvider playerProvider;
  late File file;
  late Stream<Duration> positionSubscription;
  int? currentIndex;
  bool skipped = false;

  @override
  void initState() {
    super.initState();
    file = File(Provider.of<PlaylistProvider>(context, listen: false).current);

    playerStatusProvider =
        Provider.of<PlayerStatusProvider>(context, listen: false);
    playerProvider = Provider.of<PlayerProvider>(context, listen: false);

    positionSubscription = playerProvider.audioPlayer.positionStream;

    positionSubscription.listen((newPostion) {
      if (mounted) {
        playerStatusProvider.changePosition(
            newPostion, playerStatusProvider.duration);
      }
    });

    playerProvider.audioPlayer.playbackEventStream.listen((event) {
      currentIndex ??= event.currentIndex;
      if (currentIndex != event.currentIndex &&
          currentIndex != null &&
          mounted) {
        if (!skipped) {
          int direction = currentIndex! < event.currentIndex! ? 0 : 1;
          nagivateToNewPlayer(context, direction);
          skipped = true;
        }
      }
    });

    Timer.periodic(Duration(seconds: 5), (timer) async {
      final prefs = await SharedPreferences.getInstance();
      prefs.setInt("played", playerStatusProvider.current.inMilliseconds);
    });
  }

  int seekLocation(double value, Duration? duration) {
    if (duration != null) {
      return (value * duration.inSeconds).toInt();
    }
    return 0;
  }

  void nagivateToNewPlayer(context, int direction) {
    PlaylistProvider playlistProvider =
        Provider.of<PlaylistProvider>(context, listen: false);
    PlayerProvider playerProvider =
        Provider.of<PlayerProvider>(context, listen: false);

    int newIndex = playerProvider.audioPlayer.sequenceState?.currentIndex ?? 0;

    playlistProvider.setCurrent(
        context, playlistProvider.playlist[newIndex].path);

    PlayerUI player = PlayerUI();

    Navigator.pushReplacement(
        context,
        PageTransition(
            child: player,
            type: direction == 1
                ? PageTransitionType.leftToRightWithFade
                : PageTransitionType.rightToLeftWithFade));
    playerProvider.changePlayer(
      newPlayer: player,
    );
  }

  void nagivateToHome() {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void handleShuffle(context) async {
    PlaylistProvider playlistProvider =
        Provider.of<PlaylistProvider>(context, listen: false);
    playlistProvider.shuffle(context);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("shuffle", playlistProvider.mode);
  }

  void handleLoop() {
    playerStatusProvider.alterRepetition();
    if (playerStatusProvider.repeat) {
      playerProvider.audioPlayer.setLoopMode(LoopMode.one);
    } else {
      playerProvider.audioPlayer.setLoopMode(LoopMode.off);
    }
  }

  ThemeData darkThemeData = ThemeData(
      colorScheme: ColorScheme.dark(
          background: Color.fromARGB(255, 30, 28, 28),
          brightness: Brightness.dark));

  @override
  Widget build(BuildContext context) {
    bool mode = Provider.of<PlaylistProvider>(context).mode;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          nagivateToHome();
        }
      },
      child: Consumer<PlayerStatusProvider>(
        builder: (context, value, child) => MaterialApp(
          theme: darkThemeData,
          darkTheme: darkThemeData,
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent.withOpacity(0.3),
              leading: Padding(
                padding: EdgeInsets.only(left: 25),
                child: GestureDetector(
                  onTap: () => {nagivateToHome()},
                  child: Icon(
                    Icons.keyboard_arrow_down_sharp,
                    size: 40,
                  ),
                ),
              ),
            ),
            body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: playerStatusProvider.albumArt.image,
                    fit: BoxFit.cover),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 50, right: 50, top: 50, bottom: 180),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Music Image
                        GestureDetector(
                          onPanUpdate: (details) {
                            if (details.delta.dx.abs() > details.delta.dy.abs()) {
                              if (details.delta.dx < 0) {
                                playerProvider.audioPlayer.seekToNext();
                                ();
                              } else if (details.delta.dx > 0) {
                                playerProvider.audioPlayer.seekToPrevious();
                              }
                            }
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.35,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                // borderRadius: borderRadius,
                                image: DecorationImage(
                                    image: playerStatusProvider.albumArt.image)),
                          ),
                        ),
                  
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Text(
                                playerStatusProvider.trackName,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Text(
                              playerStatusProvider.artistName,
                              textAlign: TextAlign.left,
                            )
                          ],
                        ),
                  
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                          child: Column(
                            children: [
                              SliderTheme(
                                data: SliderThemeData(
                                  trackShape: CustomSlider(),
                                  thumbColor: Colors.white,
                                  activeTrackColor: Colors.white,
                                  inactiveTrackColor:
                                      Color.fromARGB(255, 144, 144, 144),
                                ),
                                child: Slider(
                                  onChanged: (double value) async {
                                    await playerProvider.audioPlayer.seek(Duration(
                                        seconds: seekLocation(
                                            value, playerStatusProvider.duration)));
                                  },
                                  value: min(value.percentageComplete, 1),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  value.current > playerStatusProvider.duration
                                      ? Text(formatter.formatDuration(
                                          playerStatusProvider.duration))
                                      : Text(
                                          formatter.formatDuration(value.current)),
                                  Text(formatter.formatDuration(
                                      playerStatusProvider.duration))
                                ],
                              )
                            ],
                          ),
                        ),
                  
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () => {handleShuffle(context)},
                              child: Icon(
                                Icons.shuffle,
                                color: !mode ? Colors.black : Colors.purple[600],
                              ),
                            ),
                            GestureDetector(
                                onTap: () {
                                  playerProvider.audioPlayer.seekToPrevious();
                                },
                                child: Icon(Icons.skip_previous)),
                            ElevatedButton(
                              onPressed: () {
                                if (mounted) {
                                  if (playerProvider.audioPlayer.playing) {
                                    playerProvider.audioPlayer.pause();
                                  } else {
                                    playerProvider.audioPlayer.play();
                                  }
                                }
                              },
                              child: Icon(playerProvider.audioPlayer.playing
                                  ? Icons.pause
                                  : Icons.play_arrow),
                            ),
                            GestureDetector(
                                onTap: () {
                                  playerProvider.audioPlayer.seekToNext();
                                  ();
                                },
                                child: Icon(Icons.skip_next)),
                            GestureDetector(
                              onTap: handleLoop,
                              child: Icon(
                                Icons.repeat_rounded,
                                color: !value.repeat
                                    ? Colors.black
                                    : Colors.purple[600],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomSlider extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final trackHeight = sliderTheme.trackHeight! / 2;
    final trackLeft = offset.dx;
    final trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;
    final trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
