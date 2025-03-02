import 'dart:core';
import 'dart:io';

import 'package:omnimusic/playerState.dart';
import 'package:omnimusic/playerSummary.dart';
import 'package:omnimusic/trackEntry.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:omnimusic/trackInfo.dart';
import 'package:permission_handler/permission_handler.dart';

final player = AudioPlayer();
List<String> files = [];

OmniPlayerState playerState = new OmniPlayerState(player: player);

List<String> scanFiles(String path) {
  List<String> result = [];
  Directory dir = Directory(path);

  if (dir.existsSync()) {
    dir.listSync().forEach((FileSystemEntity entity) {
      if (entity is File) {
        result.add(entity.path);
      }
    });
  } else {
    print("`${path}` reading error");
  }

  return result;
}

String? homeDir() {
  return Platform.environment['HOME'] // Linux
      ??
      Platform.environment['USERPROFILE'] // Windows
      ??
      '/sdcard'; // Android
}

void main() {
  var path = "${homeDir()!}/Music/";
  files = scanFiles(path);

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
  Widget build(BuildContext context) {
    var rds =
        files.map((var path) {
          return Container(
            padding: EdgeInsets.all(4),
            child: TrackEntry(
              state: playerState,
              info: TrackInfo.readFromFile(path)
            ),
          );
        }).toList();

    var tracklist = Expanded(
      child: ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: rds,
      ),
    );

    var pentry = PlayerSummary(state: playerState);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[Text('Hello, world! (${files})'), tracklist, pentry],
      ),
    );
  }
}
