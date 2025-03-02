import 'dart:ffi';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:omnimusic/playerState.dart';
import 'package:omnimusic/tools.dart';
import 'package:omnimusic/trackInfo.dart';

class TrackEntry extends StatelessWidget {
  final OmniPlayerState state;
  final TrackInfo info;

  const TrackEntry({super.key, required this.state, required this.info});

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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(info.title, style: TextStyle(fontSize: 16)),
              Text(info.artist),
            ],
          ),
          Text(durationToTime(info.duration)),
        ],
      ),
    );

    return GestureDetector(
      onTap: () {
        state.player.stop();
        state.player.play(DeviceFileSource(info.path));

        state.currentTrackInfo = info;
      },
      child: ctr,
    );
  }
}
