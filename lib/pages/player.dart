// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, must_be_immutable, prefer_const_constructors_in_immutables

import "dart:async";
import "dart:math";

import "package:flutter/material.dart";
import "package:just_audio/just_audio.dart";
import "package:music/providers/files_provider.dart";
import 'dart:io';
import "package:music/providers/player_status_provider.dart";
import "package:music/providers/player_provider.dart";
import "package:music/providers/playlist_provider.dart";

import "package:music/utils/format_data.dart" as formatter;
import "package:page_transition/page_transition.dart";
import "package:provider/provider.dart";

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
  bool skipped = false;

  @override
  void initState() {
    super.initState();
    file = File(Provider.of<PlaylistProvider>(context, listen: false).current);

    playerStatusProvider =
        Provider.of<PlayerStatusProvider>(context, listen: false);
    playerProvider = Provider.of<PlayerProvider>(context, listen: false);
    playerStatusProvider.set(context, file.path);

    positionSubscription = playerProvider.audioPlayer.positionStream;

    positionSubscription.listen((newPostion) {
      final duration =
          playerProvider.audioPlayer.duration ?? Duration(seconds: 10000000);
      if (!playerStatusProvider.repeat && newPostion >= duration && mounted) {
        if (!skipped) {
          playerProvider.audioPlayer.seekToNext();
          nagivateToNewPlayer(context, 0);
          skipped = true;
        }
      } else {
        skipped = false;
      }

      if (mounted) {
        playerStatusProvider.changePosition(
            newPostion, playerStatusProvider.duration);
      }
    });
  }

  int seekLocation(double value, Duration? duration) {
    if (duration != null) {
      return (value * duration.inSeconds).toInt();
    }
    return 0;
  }

  void nagivateToNewPlayer(context, int direction) {
    FilesProvider filesProvider =
        Provider.of<FilesProvider>(context, listen: false);
    PlaylistProvider playlistProvider = Provider.of<PlaylistProvider>(context, listen: false);

    final playerProvider = Provider.of<PlayerProvider>(context, listen: false);
    late int newIndex =
        playerProvider.audioPlayer.sequenceState?.currentIndex ?? 0;
    print("$newIndex\n\n\n\n\n");
    if (direction == 0) {
      newIndex = (newIndex + 1) % filesProvider.musicFiles.length;
    } else {
      newIndex = (newIndex - 1) % filesProvider.musicFiles.length;
    }
    print("$newIndex\n\n\n\n\n");

    print("${filesProvider.musicFiles[newIndex]}}\n\n\n\n\n\n\n\n\n\n");
    playlistProvider.setCurrent(filesProvider.musicFiles[newIndex].path);

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

  void handleShuffle(context) {
    PlaylistProvider playlistProvider =
        Provider.of<PlaylistProvider>(context, listen: false);
    playlistProvider.shuffle();
  }

  void handleLoop() {
    playerStatusProvider.alterRepetition();
    if (playerStatusProvider.repeat) {
      // playerProvider.audioPlayer.setReleaseMode(ReleaseMode.loop);
      playerProvider.audioPlayer.setLoopMode(LoopMode.one);
    } else {
      playerProvider.audioPlayer.setLoopMode(LoopMode.off);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool mode = Provider.of<PlaylistProvider>(context).mode;
    // AudioPlayer audioPlayer = Provider.of<PlayerProvider>(context).audioPlayer;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          nagivateToHome();
        }
      },
      child: Consumer<PlayerStatusProvider>(
        builder: (context, value, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            appBar: AppBar(
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
            body: Padding(
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
                          nagivateToNewPlayer(context, 0);
                        } else if (details.delta.dx > 0) {
                          playerProvider.audioPlayer.seekToPrevious();
                          nagivateToNewPlayer(context, 1);
                        }
                      }
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.35,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: playerStatusProvider.albumArt.image)),
                    ),
                  ),

                  Column(
                    children: [
                      Text(playerStatusProvider.trackName),
                      Text(playerStatusProvider.artistName)
                    ],
                  ),

                  Column(
                    children: [
                      Slider(
                        onChanged: (double value) async {
                          await playerProvider.audioPlayer.seek(Duration(
                              seconds: seekLocation(
                                  value, playerStatusProvider.duration)));
                        },
                        value: min(value.percentageComplete, 1),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          value.current > playerStatusProvider.duration
                              ? Text(formatter.formatDuration(
                                  playerStatusProvider.duration))
                              : Text(formatter.formatDuration(value.current)),
                          Text(formatter
                              .formatDuration(playerStatusProvider.duration))
                        ],
                      )
                    ],
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
                            nagivateToNewPlayer(context, 1);
                          },
                          child: Icon(Icons.skip_previous)),
                      ElevatedButton(
                        onPressed: () {
                          if (mounted) {
                            playerStatusProvider
                                .alterPlayStatus(playerProvider.audioPlayer);
                          }
                        },
                        child: Icon(
                            value.isPlaying ? Icons.pause : Icons.play_arrow),
                      ),
                      GestureDetector(
                          onTap: () {
                            playerProvider.audioPlayer.seekToNext();
                            ();
                            nagivateToNewPlayer(context, 0);
                          },
                          child: Icon(Icons.skip_next)),
                      GestureDetector(
                        onTap: handleLoop,
                        child: Icon(
                          Icons.repeat_rounded,
                          color:
                              !value.repeat ? Colors.black : Colors.purple[600],
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
    );
  }
}
