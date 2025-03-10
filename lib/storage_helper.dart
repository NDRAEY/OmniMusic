import 'dart:io';

import 'package:omnimusic/filesystem.dart';
import 'package:omnimusic/trackInfo.dart';
import 'package:on_audio_query/on_audio_query.dart';

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

List<TrackInfo> getTracks() {
  if (Platform.isAndroid) {
    final OnAudioQuery audioQuery = OnAudioQuery();
    List<TrackInfo> tracks = [];
    bool wait = true;

    audioQuery.querySongs().then((List<SongModel> value) {
      tracks = value.map((var song) {
        return TrackInfo.fromSong(song);
      }).toList();

      wait = false;
    });

    while(wait) {
      continue;
    }

    return tracks;
  } else {
    var path = "${homeDir()!}/Music/";

    return filesToTracks(scanFiles(path));
  }
}