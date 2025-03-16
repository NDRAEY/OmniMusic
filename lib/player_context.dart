import 'dart:developer';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:omnimusic/main.dart';
import 'package:omnimusic/player_state.dart';
import 'package:omnimusic/track_info.dart';
import 'package:uri_to_file/uri_to_file.dart';

class PlayerContext {
  final OmniPlayerState state;
  final List<TrackInfo> tracks;
  List<TrackInfo> filteredTracks = [];
  int currentTrackIndex = 0;

  PlayerContext({
    required this.state,
    required this.tracks
  });

  void filterBy(String query) {
    filteredTracks = tracks.where((info) {
      var inTitle = info.title.toLowerCase().contains(query.toLowerCase());
      var inArtist = info.artist.toLowerCase().contains(query.toLowerCase());
      
      return inArtist || inTitle;
    }).toList();
  }

  void reloadTrack() async {
    state.player.stop();

    state.currentTrackInfo = filteredTracks[currentTrackIndex];
    
    var path = state.currentTrackInfo!.path;

    if(Platform.isAndroid) {
      var file = await toFile(path);
      debugPrint(file.toString());

      path = file.path;
    }

    state.player.play(DeviceFileSource(path));
  }

  void playNth(int idx) {
    state.player.stop();

    if(!(idx >= 0 && idx < filteredTracks.length)) {
      debugPrint('Out of index: $idx in range [0..${filteredTracks.length}]');
      return;
    }

    currentTrackIndex = idx;

    reloadTrack();
  }

  void previous() {
    state.player.stop();

    if(currentTrackIndex > 0) {
      currentTrackIndex -= 1;
    } else {
      currentTrackIndex = filteredTracks.length - 1;
    }

    reloadTrack();
  }

  void next() {
    state.player.stop();
    
    if(currentTrackIndex < filteredTracks.length - 1) {
      currentTrackIndex += 1;
    } else {
      currentTrackIndex = 0;
    }

    reloadTrack();
  }

  void sortFiltered(SortMode sort_mode, bool reverse) {
    filteredTracks.sort((prev, next) {
      if(sort_mode == SortMode.title) {
        return prev.title.compareTo(next.title);
      } else if(sort_mode == SortMode.artist) {
        return prev.artist.compareTo(next.artist);
      } else if(sort_mode == SortMode.duration) {
        return prev.duration!.compareTo(next.duration!);
      } else if(sort_mode == SortMode.dateAdded) {
        return prev.additionDate.compareTo(next.additionDate);
      } else {
        return next.title.compareTo(prev.title);
      }
    });

    if(reverse) {
      filteredTracks = filteredTracks.reversed.toList();
    }
  }
}