import 'package:audioplayers/audioplayers.dart';
import 'package:omnimusic/trackInfo.dart';

class OmniPlayerState {
  final AudioPlayer player;

  TrackInfo? currentTrackInfo = null;
  
  OmniPlayerState({
    required this.player
  });
}