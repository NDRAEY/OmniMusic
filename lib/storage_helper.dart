import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:omnimusic/filesystem.dart';
import 'package:omnimusic/track_info.dart';
import 'package:on_audio_query_forked/on_audio_query.dart';

import 'dart:developer';

List<String> scanFiles(String path) {
  List<String> result = [];
  Directory dir = Directory(path);

  if (dir.existsSync()) {
    dir.listSync().forEach((FileSystemEntity entity) {
      if (entity is File) {
        result.add(entity.path);
      }
    });
  }

  return result;
}

List<TrackInfo> filesToTracks(List<String> files) {
  return files.map((var path) {
    return TrackInfo.readFromFile(path);
  }).toList();
}

Future<List<TrackInfo>> getTracks() async {
  if (Platform.isAndroid) {
    final OnAudioQuery audioQuery = OnAudioQuery();

    var tracks = await audioQuery.querySongs();
    
    List<TrackInfo> prep = [];

    for (var song in tracks) {
      prep.add(await TrackInfo.fromSong(song));
    }

    return prep.toList();
  } else
  {
    var path = "${homeDir()!}/Music/";

    return filesToTracks(scanFiles(path));
  }
}
