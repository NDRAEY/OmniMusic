import 'dart:io';

import 'package:audio_metadata_reader/audio_metadata_reader.dart';
import 'package:on_audio_query_platform_interface/src/models/song_model.dart';

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

  static TrackInfo fromSong(SongModel song) {
    return TrackInfo(
      path: song.uri!,
      title: song.title,
      artist: song.artist!,
      duration: Duration(seconds: song.duration!)
    );
  }
}