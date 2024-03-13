import 'dart:collection';

import 'package:flutter/material.dart';

class RequiredMetadata {
  String trackName;
  String artistName;
  Duration trackDuration;
  Image albumArt;

  RequiredMetadata(
      this.trackName, this.artistName, this.trackDuration, this.albumArt);
}

final Map<String, RequiredMetadata> initialMetadataMap =
    HashMap<String, RequiredMetadata>();

class MetadataProvider extends ChangeNotifier {
  Map<String, RequiredMetadata> _metadataMap = {};

  Map<String, RequiredMetadata> get metadataMap => _metadataMap;

  Future<void> addRequiredMetadata(
      {required Map<String, RequiredMetadata> newMetadataMap}) async {
    Map<String, RequiredMetadata> updatedMap =
        Map.unmodifiable({..._metadataMap, ...newMetadataMap});

    _metadataMap = updatedMap;
  }
}
