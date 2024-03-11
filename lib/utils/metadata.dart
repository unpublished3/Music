import 'dart:io';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';

Future<Metadata> getMetadata(String filePath) async {
  return await MetadataRetriever.fromFile(File((filePath)));
}
