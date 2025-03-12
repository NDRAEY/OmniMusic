import 'dart:developer';
import 'dart:io';

import 'package:audio_metadata_reader/audio_metadata_reader.dart';
import 'package:flutter/foundation.dart';
import 'package:on_audio_query_forked/on_audio_query.dart';
import 'package:uri_to_file/uri_to_file.dart';

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

  static Future<TrackInfo> fromSong(SongModel song) async {
    var uri = song.uri!;

    return TrackInfo(
      path: uri,
      title: song.title,
      artist: song.artist!,
      duration: Duration(milliseconds: song.duration!)
    );
  }
}
