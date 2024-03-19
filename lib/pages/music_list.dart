// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:music/pages/list.dart';
import 'package:music/providers/files_provider.dart';
import 'package:music/providers/metadata_provider.dart';

import 'package:music/utils/find_music_files.dart';
import 'package:music/utils/metadata.dart';
import 'package:provider/provider.dart';

class MusicList extends StatelessWidget {
  MusicList({super.key});

  Future<void> updateMusicFiles(context) async {
    List<File> files = await findMp3Files();
    FilesProvider filesProvider =
        Provider.of<FilesProvider>(context, listen: false);
    filesProvider.addFiles(files);

    for (File file in files) {
      await setMetadata(context, file);
    }
  }

  Future<void> setMetadata(context, File file) async {
    RequiredMetadata requiredMetadata = await getMetadata(file.path);

    MetadataProvider myProvider =
        Provider.of<MetadataProvider>(context, listen: false);
    myProvider
        .addRequiredMetadata(newMetadataMap: {file.path: requiredMetadata});
  }

  @override
  Widget build(BuildContext context) {
    FilesProvider filesProvider =
        Provider.of<FilesProvider>(context, listen: false);
    List<File> musicFiles = filesProvider.musicFiles;

    return FutureBuilder<void>(
      future: updateMusicFiles(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while waiting for permission result
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Handle any errors
          return Scaffold(body: Center(child: Text('Error occurred')));
        } else {
          return ListView.builder(
              itemCount: musicFiles.length,
              itemBuilder: ((context, index) =>
                  ListUI(file: musicFiles[index])));
        }
      },
    );
  }
}
