import 'dart:developer';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:omnimusic/playerState.dart';
import 'package:omnimusic/trackInfo.dart';
import 'package:uri_to_file/uri_to_file.dart';

class PlayerContext {
  final OmniPlayerState state;
  final List<TrackInfo> tracks;
  int currentTrackIndex = 0;

  PlayerContext({
    required this.state,
    required this.tracks
  });

  void reloadTrack() async {
    state.player.stop();

    state.currentTrackInfo = tracks[currentTrackIndex];
    
    var path = state.currentTrackInfo!.path;

    if(Platform.isAndroid) {
      var file = await toFile(path);
      debugPrint(file.toString());

      path = file.path;
    }

    state.player.play(DeviceFileSource(path));
  }

  void playNth(int idx) {
    if(!(idx >= 0 && idx < tracks.length)) {
      debugPrint('Out of index: $idx in range [0..${tracks.length}]');
      return;
    }

    currentTrackIndex = idx;

    reloadTrack();
  }

  void previous() {
    if(currentTrackIndex > 0) {
      currentTrackIndex -= 1;
    } else {
      currentTrackIndex = tracks.length - 1;
    }

    reloadTrack();
  }

  void next() {
    if(currentTrackIndex < tracks.length - 1) {
      currentTrackIndex += 1;
    } else {
      currentTrackIndex = 0;
    }

    reloadTrack();
  }
}