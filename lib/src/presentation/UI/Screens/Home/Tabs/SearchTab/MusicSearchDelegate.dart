// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:music_app/src/data/repository/UserRepository.dart';
import 'package:music_app/src/presentation/UI/Screens/Home/Tabs/SearchTab/musicSearchDelegate/widget/ClearSearchHistoryWidget.dart';
import 'package:music_app/src/presentation/core/widgets/BuildSongTileItem.dart';
import 'package:music_app/src/presentation/core/widgets/BuildAssetIcon.dart';
import 'package:music_app/src/domain/model/song/NetworkSong.dart';
import 'package:music_app/src/presentation/service/ColorService.dart';
import 'package:music_app/src/data/api/service/FirebaseFireStoreService.dart';

class MusicSearch extends SearchDelegate<String>{

  /// All searchable songs
  List<NetworkSong> songs = [];

  /// Songs that were checked before .
  late  List<int> recentlySongs;

  MusicSearch (){
    FirebaseFireStoreService().fetchAllSongs().then((songs) => this.songs = songs);
    UserRepository.fetchSongSearchHistory().then((ids)  =>  recentlySongs = ids);
  }


  @override
  ThemeData appBarTheme(BuildContext context) => Theme.of(context);


  @override
  List<Widget>? buildActions(BuildContext context) => [
    InkWell(
        onTap: () => query.isNotEmpty ? query = "" : Navigator.of(context).pop(),
        child: const BuildAssetIcon(
          iconName: "close",
        )
    )
  ];

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back)
    );
  }

  @override
  Widget buildResults(BuildContext context) {

    // final labelSmall = Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 22);

    return Column(
      children: [
        Text(
          songs.map((e) => e.searchFormat).contains(query) ? query : "No song found"  , style:  TextStyle(color: white),)
      ],
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
     final List<NetworkSong> buildSong = sortSuggestions();


    return Column(
      children: [
        query.isNotEmpty ? Container() : ClearSearchHistory(
          onTap: () async {
            recentlySongs = [];
            query = "";
            await UserRepository.removeHistorySongs();
          },
        ),
        Expanded(
          child: ListView.builder(
              itemCount: buildSong.length,
              itemBuilder: (context , index) {
                return BuildSongTileItem(
                  onTap: () {
                    onTap(buildSong[index]);
                  },
                  songs: buildSong,
                  song: buildSong[index],
                );
              }
          ),
        ),
      ],
    );
  }



  List<NetworkSong> sortSuggestions () {

    if( query.isEmpty) {
      return convertHistoryIdToSong();
    }else {
      return  songs.where((song) {
        final String songLower = song.searchFormat.toLowerCase();
        final queryLower = query.toLowerCase();

        return songLower.startsWith(queryLower);

      }).toList();
    }

  }

  List<NetworkSong> convertHistoryIdToSong () {
    final List<NetworkSong> buildSong = [];

    for (var song in songs) {
      if(recentlySongs.contains(song.id)){
        buildSong.add(song);
      }
    }
    return buildSong;
  }

  /// add new song to history and prevent identical songs.
  void onTap (NetworkSong buildSong) {
    recentlySongs..add(buildSong.id)..toSet()..toList();
    UserRepository.updateHistorySongs(recentlySongs);
  }


}
