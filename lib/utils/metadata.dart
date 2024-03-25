import 'package:flutter/material.dart';
import 'package:metadata_god/metadata_god.dart';
import 'package:music/providers/metadata_provider.dart';
import 'package:path/path.dart';

Future<RequiredMetadata> getMetadata(String filePath) async {
  // final audioMetadata = await MetadataRetriever.fromFile(File((filePath)));
  final audioMetadata = await MetadataGod.readMetadata(file: filePath);

  return RequiredMetadata(
      trackName(filePath, audioMetadata.title),
      artistName(audioMetadata.artist),
      trackDuration(audioMetadata.durationMs),
      albumArt(audioMetadata.picture));
}

String trackName(String filePath, String? trackName) {
  if (trackName != null) {
    return basenameWithoutExtension(trackName);
  }

  return basenameWithoutExtension(filePath);
}

String artistName(String? trackArtistNames) {
  if (trackArtistNames != null) {
    return trackArtistNames;
  }

  return "";
}

Duration trackDuration(double? trackDuration) {
  if (trackDuration != null) {
    return Duration(milliseconds: trackDuration.toInt());
  }

  return Duration.zero;
}

Image albumArt(Picture? art) {
  if (art != null) {
    art.mimeType;
    return Image.memory(art.data)
    ;
  }

  return Image.asset("assets/image.jpg");
}
