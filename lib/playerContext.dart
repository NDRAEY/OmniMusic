import 'package:audioplayers/audioplayers.dart';
import 'package:omnimusic/playerState.dart';
import 'package:omnimusic/trackInfo.dart';

class PlayerContext {
  final OmniPlayerState state;
  final List<TrackInfo> tracks;
  int currentTrackIndex = 0;

  PlayerContext({
    required this.state,
    required this.tracks
  });

  void reloadTrack() {
    state.currentTrackInfo = tracks[currentTrackIndex];
    state.player.play(DeviceFileSource(state.currentTrackInfo!.path));
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