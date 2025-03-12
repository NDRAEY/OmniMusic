import 'dart:core';
import 'dart:developer';
import 'dart:io';

import 'package:omnimusic/playerContext.dart';
import 'package:omnimusic/playerState.dart';
import 'package:omnimusic/playerSummary.dart';
import 'package:omnimusic/storage_helper.dart';
import 'package:omnimusic/trackEntry.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      Permission.storage.request().then((value) {
        debugPrint("$value");
      });

      Permission.mediaLibrary.request().then((value) {
        debugPrint("$value");
      });
    }

    return MaterialApp(
      title: 'OmniMusic',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'OmniMusic'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late AudioPlayer player;

  PlayerContext? playerContext;

  @override
  void initState() {
    super.initState();

    player = AudioPlayer();
    var tracks = getTracks();
    tracks.then((d) {
      setState(() {
        debugPrint('$d');
        playerContext = PlayerContext(
          state: OmniPlayerState(player: player),
          tracks: d,
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (playerContext == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [CircularProgressIndicator(), Text("Getting ready...")]
          )
        )
      );
    }

    var tracklist = Expanded(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: playerContext!.tracks.length,
        prototypeItem: Container(
            padding: const EdgeInsets.all(4),
            child: TrackEntry(key: ValueKey(0), p_context: playerContext!, info: playerContext!.tracks.first, listindex: 0),
        ),
        itemBuilder: (context, index) {
          var track = playerContext!.tracks[index];

          return Container(
            padding: const EdgeInsets.all(4),
            child: TrackEntry(key: ValueKey(index), p_context: playerContext!, info: track, listindex: index),
          );
        },
      ),
    );

    var pentry = PlayerSummary(context: playerContext!);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          tracklist,
          Container(padding: EdgeInsets.all(8), child: pentry),
        ],
      ),
    );
  }
}
