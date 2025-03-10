import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:omnimusic/playerContext.dart';
import 'package:omnimusic/playerState.dart';
import 'package:omnimusic/tools.dart';

class PlayerSummary extends StatefulWidget {
  final PlayerContext context;

  const PlayerSummary({super.key, required this.context});

  @override
  State<PlayerSummary> createState() => _PlayerSummaryState();
}

class _PlayerSummaryState extends State<PlayerSummary> {
  Duration? currentPosition;
  double pos = 0.0;

  @override
  void initState() {
    super.initState();

    widget.context.state.player.onPositionChanged.listen((dur) {
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
        if (widget.context.state.player.state == PlayerState.playing) {
          widget.context.state.player.pause();
        } else {
          widget.context.state.player.resume();
        }
      },
      child: Icon(
        widget.context.state.player.state == PlayerState.playing
            ? Icons.pause
            : Icons.play_arrow,
        size: 32.0,
      ),
    );

    var prevButton = GestureDetector(
      onTap: () {
        widget.context.previous();
      },
      child: Icon(Icons.skip_previous, size: 32.0),
    );

    var nextButton = GestureDetector(
      onTap: () {
        widget.context.next();
      },
      child: Icon(Icons.skip_next, size: 32.0),
    );

    var progress = Slider(
      value: currentPosition?.inSeconds.toDouble() ?? 0.0,
      max: widget.context.state.currentTrackInfo?.duration?.inSeconds.toDouble() ?? 0.0,
      onChanged: (val) {
        setState(() {
          currentPosition = Duration(milliseconds: (val * 1000).toInt());

          widget.context.state.player.seek(currentPosition!);
        });
      },
      padding: EdgeInsets.all(2),
    );

    var trackPosition = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.only(right: 16.0),
          child: Text(durationToTime(currentPosition)),
        ),
        Expanded(child: progress),
        Container(
          padding: EdgeInsets.only(left: 16.0),
          child: Text(durationToTime(widget.context.state.currentTrackInfo?.duration)),
        ),
      ],
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
        child: Column(
          children: [
            trackPosition,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.context.state.currentTrackInfo?.title ?? "No Data",
                        style: TextStyle(
                          fontSize: 16,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(widget.context.state.currentTrackInfo?.artist ?? "No Data"),
                    ],
                  ),
                ),
                prevButton,
                playButton,
                nextButton,
              ],
            ),
          ],
        ),
      ),
    );
  }
}
