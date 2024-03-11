// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:music/utils/metadata.dart';
import 'dart:io';
import 'package:path/path.dart';

class ListUI extends StatefulWidget {
  // ListUI({super.key});
  File file;

  ListUI({super.key, required this.file});

  @override
  State<ListUI> createState() => _ListUIState();
}

class _ListUIState extends State<ListUI> {
  late Metadata audioMetadata;

  String formatName(String name) {
    if (name.length > 30) {
      return '${name.substring(0, 30)}.....';
    }
    return name;
  }

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
      return formatName(basenameWithoutExtension(track));
    }

    return formatName(basenameWithoutExtension(widget.file.path));
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
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black, width: 2)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 0),
                        child: Column(
                          children: [Text(trackName), Text("Artist")],
                        ),
                      )
                    ],
                  ),
                  Text("Length")
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
