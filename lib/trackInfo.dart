import 'dart:io';

import 'package:audio_metadata_reader/audio_metadata_reader.dart';

class TrackInfo {
  String path;

  String title;
  String artist;
  Duration? duration;

  TrackInfo({required this.path, required this.title,  required this.artist, required this.duration});

  static TrackInfo readFromFile(String path) {
    final track = File(path);
    final metadata = readMetadata(track, getImage: false);

    return TrackInfo(
      path: path,
      title: metadata.title ?? path,
      artist: metadata.artist ?? "Unknown artist",
      duration: metadata.duration
    );
  }
}