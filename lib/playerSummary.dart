import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:omnimusic/playerState.dart';
import 'package:omnimusic/tools.dart';

class PlayerSummary extends StatefulWidget {
  final OmniPlayerState state;

  PlayerSummary({super.key, required this.state});

  @override
  State<PlayerSummary> createState() => _PlayerSummaryState();
}

class _PlayerSummaryState extends State<PlayerSummary> {
  Duration? currentPosition;

  @override
  void initState() {
    super.initState();

    widget.state.player.onPositionChanged.listen((dur) {
      // Handle position updates
      setState(() {
        currentPosition = dur;
      }); // Update UI if necessary
    });
  }

  @override
  Widget build(BuildContext context) {
    var playButton = GestureDetector(
      onTap: () {
        if(widget.state.player.state == PlayerState.playing) {
          widget.state.player.pause();
        } else {
          widget.state.player.resume();
        }
      },
      child: Text(widget.state.player.state == PlayerState.playing ? "PAUSE" : "PLAY")
    );

    return GestureDetector(
      onTap: () {
        // Handle tap
      },
      child: Container(
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
                Text(widget.state.currentTrackInfo?.title ?? "No Data", style: TextStyle(fontSize: 16)),
                Text(widget.state.currentTrackInfo?.artist ?? "No Data"),
              ],
            ),
            Text(durationToTime(currentPosition)),
            Text("BKWD"),
            playButton,
            Text("FWD"),
          ],
        ),
      ),
    );
  }
}
