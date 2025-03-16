import 'dart:core';
import 'dart:io';

import 'package:omnimusic/player_context.dart';
import 'package:omnimusic/player_state.dart';
import 'package:omnimusic/player_summary.dart';
import 'package:omnimusic/repeat.dart';
import 'package:omnimusic/storage_helper.dart';
import 'package:omnimusic/track_entry.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:omnimusic/track_info.dart';
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

enum SortMode { title, artist, duration, dateAdded }

SortMode switch_sort_mode(SortMode mode) {
  return mode == SortMode.title
      ? SortMode.artist
      : mode == SortMode.artist
      ? SortMode.duration
      : mode == SortMode.duration
      ? SortMode.dateAdded
      : SortMode.title;
}

String sortmode_to_string(SortMode mode) {
  return mode == SortMode.title
      ? "Название"
      : mode == SortMode.artist
      ? "Исполнитель"
      : mode == SortMode.duration
      ? "Длительность"
      : "Добавлено";
}

class _MyHomePageState extends State<MyHomePage> {
  late AudioPlayer player;

  PlayerContext? playerContext;
  bool is_searching = false;
  late TextEditingController search_controller;

  SortMode sort_mode = SortMode.title;
  bool is_sort_reversed = false;

  @override
  void initState() {
    super.initState();

    player = AudioPlayer();

    var tracks = getTracks();
    tracks.then((d) {
      setState(() {
        playerContext = PlayerContext(
          state: OmniPlayerState(player: player),
          tracks: d,
        );

        playerContext!.filterBy("");

        player.onPlayerComplete.listen((event) {
          setState(() {
            var repeat = playerContext!.state.repeat;

            if (repeat == RepeatMode.all) {
              playerContext!.next();
            } else if (repeat == RepeatMode.one) {
              playerContext!.reloadTrack();
            }
          });
        });
      });
    });

    search_controller = TextEditingController();
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
            children: [CircularProgressIndicator(), Text("Getting ready...")],
          ),
        ),
      );
    }

    var tracklist = Expanded(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: playerContext!.filteredTracks.length,
        prototypeItem: Container(
          padding: const EdgeInsets.all(4),
          child: TrackEntry(
            key: ValueKey(0),
            p_context: playerContext!,
            info: TrackInfo(
              path: "",
              artist: "",
              title: "",
              duration: Duration(hours: 0),
              additionDate: DateTime.now(),
            ),
            listindex: 0,
          ),
        ),
        itemBuilder: (context, index) {
          var track = playerContext!.filteredTracks[index];

          return Container(
            padding: const EdgeInsets.all(4),
            child: TrackEntry(
              key: ValueKey(index),
              p_context: playerContext!,
              info: track,
              listindex: index,
            ),
          );
        },
      ),
    );

    var pentry = PlayerSummary(context: playerContext!);

    var searchbar = TextField(
      controller: search_controller,
      onChanged: (data) {
        setState(() {
          playerContext!.filterBy(data);
          playerContext!.sortFiltered(sort_mode, is_sort_reversed);
        });
      },
    );

    var searchField = Row(
      children: [
        GestureDetector(
          child: const Icon(Icons.arrow_back_ios_new),
          onTap: () {
            setState(() {
              is_searching = false;
            });
          },
        ),
        Expanded(child: searchbar),
      ],
    );

    var sortWidget = GestureDetector(
      child: Container(
        padding: const EdgeInsets.only(right: 8),
        child: Row(
          children: [
            Text(
              "${sortmode_to_string(sort_mode)} ",
              style: TextStyle(fontSize: 15),
            ),
            Icon(Icons.sort),
          ],
        ),
      ),
      onTap: () {
        setState(() {
          sort_mode = switch_sort_mode(sort_mode);
          playerContext!.sortFiltered(sort_mode, is_sort_reversed);
        });
      },
    );

    var sortInvertButton = GestureDetector(
      child: Container(
        padding: const EdgeInsets.only(right: 8),
        child: Icon(is_sort_reversed ? Icons.rotate_left : Icons.rotate_left_outlined),
      ),
      onTap: () {
        setState(() {
          is_sort_reversed = !is_sort_reversed;
          playerContext!.sortFiltered(sort_mode, is_sort_reversed);
        });
      },
    );

    var searchButton = GestureDetector(
      child: Container(
        padding: EdgeInsets.only(right: 8),
        child: const Icon(Icons.search),
      ),
      onTap: () {
        setState(() {
          is_searching = true;
        });
      },
    );

    var searchActions =
        is_searching ? [sortWidget, sortInvertButton] : [searchButton];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: is_searching ? searchField : Text(widget.title),
        actions: searchActions,
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
