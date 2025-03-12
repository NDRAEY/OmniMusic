import 'dart:io';

import 'package:flutter/material.dart';
import 'package:omnimusic/playerContext.dart';
import 'package:omnimusic/tools.dart';
import 'package:omnimusic/trackInfo.dart';
import 'package:uri_to_file/uri_to_file.dart';

class TrackEntry extends StatelessWidget {
  final PlayerContext p_context;
  final TrackInfo info;
  final int listindex;

  const TrackEntry({super.key, required this.p_context, required this.info, required this.listindex});

  @override
  Widget build(BuildContext context) {
    var ctr = Container(
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 2),
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.only(right: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ListTile(
              title: Text(
                  info.title,
                  style: const TextStyle(
                    fontSize: 16,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              subtitle: Text(
                info.artist,
                style: const TextStyle(
                  fontSize: 16,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
          Text(durationToTime(info.duration)),
        ],
      ),
    );

    return GestureDetector(
      onTap: () async {
        var path = info.path;

        if(Platform.isAndroid) {
          var file = await toFile(path);

          debugPrint(file.toString());

          path = file.path;
        }

        debugPrint(path);

        p_context.playNth(listindex);

        p_context.state.currentTrackInfo = info;
      },
      child: ctr,
    );
  }
}
