import 'package:audioplayers/audioplayers.dart';
import 'package:omnimusic/repeat.dart';
import 'package:omnimusic/track_info.dart';

class OmniPlayerState {
  final AudioPlayer player;
  RepeatMode repeat = RepeatMode.none;

  TrackInfo? currentTrackInfo;
  
  OmniPlayerState({
    required this.player
  });
}