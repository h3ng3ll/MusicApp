// ignore_for_file: file_names
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:music_app/src/data/provider/AudioProvider.dart';
import 'package:music_app/src/data/provider/LibraryProvider.dart';
import 'package:music_app/src/domain/model/song/LocalSong.dart';
import 'package:music_app/src/presentation/core/widgets/BuildSongTileItem.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongsScreen extends StatefulWidget {
  const SongsScreen({Key? key}) : super(key: key);

  @override
  State<SongsScreen> createState() => _SongsScreenState();
}

class _SongsScreenState extends State<SongsScreen> {



  bool permissionGranted = false;

  final OnAudioQuery _audioQuery = OnAudioQuery();
  @override
  void initState() {

    requestStoragePermission();

    super.initState();

  }
  @override
  Widget build(BuildContext context)  {

    if(LibraryProvider.localLibrary.songs.isNotEmpty) {
      final songs = LibraryProvider.localLibrary.songs;
      AudioProvider.initialize(songs);

      if(LibraryProvider.localLibrary.songs.isEmpty ) LibraryProvider.localLibrary.songs  = songs;

      return ListView.builder(
          itemCount: songs.length,
          itemBuilder: (context , index) {
            return BuildSongTileItem(song: songs[index], songs: songs);
          }
      );
    }

    return FutureBuilder<List<SongModel>>(
        future: permissionGranted ? _audioQuery.querySongs(
          sortType: null,
          orderType: OrderType.DESC_OR_GREATER,
          uriType: UriType.EXTERNAL,
          ignoreCase: true
        ) : null,
        builder: (context , item)   {
          if(item.data == null || item.connectionState == ConnectionState.waiting ) {
            return const Center(child: CircularProgressIndicator(),);
          }
          if(item.data!.isEmpty){
            return const Center(child: Text("No available songs found"));
          }




          return FutureBuilder<List<LocalSong>>(
            future: Stream.fromIterable(item.data!).asyncMap((song)  => LocalSong.fromSongModel(song)).toList(),
            builder: (context, snapshot) {

              if(item.data == null || snapshot.connectionState == ConnectionState.waiting  ) {
                return const Center(child: CircularProgressIndicator(),);
              }
              if(item.data!.isEmpty){
                return const Center(child: Text("No available songs found"));
              }
              final lSongs = snapshot.data!;
              if(LibraryProvider.localLibrary.songs.isEmpty ) LibraryProvider.localLibrary.songs  = lSongs;
              AudioProvider.initialize(lSongs);

              return ListView.builder(
                  itemCount: lSongs.length,
                  itemBuilder: (context , index) {
                    return BuildSongTileItem(song: lSongs[index], songs: lSongs);

                  }
              );
            }
          );
        }
    );
  }

  void requestStoragePermission() async{
    if(!kIsWeb) {
      bool permission = await _audioQuery.permissionsStatus();
      if(!permission) {
       await _audioQuery.permissionsRequest();
      }
      if(await _audioQuery.permissionsStatus()){
        permissionGranted = true; setState(() { });
      }

    }
  }
}
