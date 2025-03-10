import 'dart:core';
import 'dart:io';

import 'package:omnimusic/playerContext.dart';
import 'package:omnimusic/playerState.dart';
import 'package:omnimusic/playerSummary.dart';
import 'package:omnimusic/storage_helper.dart';
import 'package:omnimusic/trackEntry.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:omnimusic/trackInfo.dart';
import 'package:permission_handler/permission_handler.dart';

late AudioPlayer player;

late PlayerContext playerContext;

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
  @override
  void initState() {
    super.initState();

    player = AudioPlayer();
    playerContext = PlayerContext(
      state: OmniPlayerState(player: player),
      tracks: getTracks(),
    );
  }

  @override
  Widget build(BuildContext context) {
    var rds =
        playerContext.tracks.map((tk) {
          return Container(
            padding: EdgeInsets.all(4),
            child: TrackEntry(p_context: playerContext, info: tk),
          );
        }).toList();

    var tracklist = Expanded(
      child: ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: rds,
      ),
    );

    var pentry = PlayerSummary(context: playerContext);

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
      // body: FutureBuilder<List<SongModel>>(
      //   future: ...,
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return Center(child: CircularProgressIndicator());
      //     } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
      //       return Center(child: Text("No music found"));
      //     }
      //     return ListView.builder(
      //       itemCount: snapshot.data!.length,
      //       itemBuilder: (context, index) {
      //         return ListTile(
      //           title: Text(snapshot.data![index].title),
      //           subtitle: Text(
      //             snapshot.data![index].artist ?? "Unknown Artist",
      //           ),
      //         );
      //       },
      //     );
      //   },
      // ),
    );
  }
}
