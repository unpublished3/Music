import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:music/providers/metadata_provider.dart';
import 'package:path/path.dart';

Future<RequiredMetadata> getMetadata(String filePath) async {
  final audioMetadata = await MetadataRetriever.fromFile(File((filePath)));
  return RequiredMetadata(
      trackName(filePath, audioMetadata.trackName),
      artistName(audioMetadata.trackArtistNames),
      trackDuration(audioMetadata.trackDuration),
      albumArt(audioMetadata.albumArt));
}

String trackName(String filePath, String? trackName) {
  if (trackName != null) {
    return basenameWithoutExtension(trackName);
  }

  return basenameWithoutExtension(filePath);
}

String artistName(List<String>? trackArtistNames) {
  String artistNames = "";
  if (trackArtistNames != null) {
    for (int i = 0; i < trackArtistNames.length; i++) {
      if (i != 0) {
        artistNames += ", ";
      }
      artistNames += trackArtistNames[i];
    }
    return artistNames;
  }

  return "";
}

Duration trackDuration(int? trackDuration) {
  if (trackDuration != null) {
    return Duration(milliseconds: trackDuration);
  }

  return Duration.zero;
}

Image albumArt(Uint8List? art) {
  if (art != null) {
    return Image.memory(art);
  }

  return Image.asset("assets/image.jpg");
}
