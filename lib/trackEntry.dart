import 'dart:ffi';

import 'package:flutter/material.dart';

String secondsToTime(int seconds) {
  int minutes = (seconds / 60).toInt();
  int secs = seconds % 60;

  String a = "$minutes".padLeft(2, "0");
  String b = "$secs".padLeft(2, "0");

  return "$a:$b";
}

class TrackEntry extends StatelessWidget {
  final String title;
  final String artist;
  final int duration;

  const TrackEntry({
    super.key,
    required this.title,
    required this.artist,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            children: [Text(title, style: TextStyle(fontSize: 16)), Text(artist)]),
          Text(secondsToTime(duration)),
        ],
      ),
    );
  }
}
