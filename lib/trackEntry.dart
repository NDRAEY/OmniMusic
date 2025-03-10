import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:omnimusic/playerContext.dart';
import 'package:omnimusic/playerState.dart';
import 'package:omnimusic/tools.dart';
import 'package:omnimusic/trackInfo.dart';

class TrackEntry extends StatelessWidget {
  final PlayerContext p_context;
  final TrackInfo info;

  const TrackEntry({super.key, required this.p_context, required this.info});

  @override
  Widget build(BuildContext context) {
    var ctr = Container(
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 2),
        borderRadius: BorderRadius.circular(4),
      ),
      padding: EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  info.title,
                  style: TextStyle(
                    fontSize: 16,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  info.artist,
                  style: TextStyle(
                    fontSize: 16,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Text(durationToTime(info.duration)),
        ],
      ),
    );

    return GestureDetector(
      onTap: () {
        p_context.state.player.stop();
        p_context.state.player.play(DeviceFileSource(info.path));

        p_context.state.currentTrackInfo = info;
      },
      child: ctr,
    );
  }
}
