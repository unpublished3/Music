// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:music/utils/metadata.dart';
import 'dart:io';
import 'package:path/path.dart';

import "package:music/utils/format_data.dart" as formatter;

class ListUI extends StatefulWidget {
  // ListUI({super.key});
  File file;

  ListUI({super.key, required this.file});

  @override
  State<ListUI> createState() => _ListUIState();
}

class _ListUIState extends State<ListUI> {
  late Metadata audioMetadata;

  @override
  void initState() {
    super.initState();
    setMetadata();
  }

  Future<void> setMetadata() async {
    audioMetadata = await getMetadata(widget.file.path);
  }

  String get trackName {
    String? track = audioMetadata.trackName;
    if (track != null) {
      return formatter.formatName(basenameWithoutExtension(track), 30);
    }

    return formatter.formatName(basenameWithoutExtension(widget.file.path), 30);
  }

  String get artistName {
    List<String>? artists = audioMetadata.trackArtistNames;
    String artistNames = "";
    if (artists != null) {
      for (int i = 0; i < artists.length; i++) {
        if (i != 0) {
          artistNames += ", ";
        }
        artistNames += artists[i];
      }
      return artistNames;
    }

    return "";
  }

  String get trackDuration {
    int? duration = audioMetadata.trackDuration;
    if (duration != null) {
      return formatter.formatDuration(Duration(milliseconds: duration));
    }

    return "0:00";
  }

  Image get albumArt {
    Uint8List? art = audioMetadata.albumArt;
    if (art != null) {
      return Image.memory(art);
    }

    return Image.asset("assets/image.jpg");
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: setMetadata(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while waiting for permission result
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Handle any errors
          return Scaffold(body: Center(child: Text('Error occurred')));
        } else {
          // Permission granted or denied
          return Padding(
            padding:
                const EdgeInsets.only(right: 20, left: 20, top: 15, bottom: 0),
            child: Container(
              padding: EdgeInsets.all(12),
              height: MediaQuery.of(context).size.height * 0.1,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(12)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.height * 0.07,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: albumArt.image, fit: BoxFit.contain),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black, width: 2)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 0),
                        child: Column(
                          children: [Text(trackName), Text(artistName)],
                        ),
                      )
                    ],
                  ),
                  Text(trackDuration)
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
