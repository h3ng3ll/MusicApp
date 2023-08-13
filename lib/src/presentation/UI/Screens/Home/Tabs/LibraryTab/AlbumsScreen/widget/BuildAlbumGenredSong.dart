// ignore_for_file: file_names



import 'package:flutter/material.dart';
import 'package:flutter_native_splash/cli_commands.dart';
import 'package:music_app/src/domain/repository/Song.dart';
import 'package:music_app/src/presentation/core/widgets/BuildHeaderTitle.dart';
import 'package:music_app/src/presentation/core/widgets/BuildSongTileItem.dart';

class BuildAlbumGenredSong extends StatelessWidget {

  final List<Song> songs;

  final String genre ;
  const BuildAlbumGenredSong({Key? key, required this.songs, required this.genre}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            BuildHeaderTitle(title: genre.capitalize(),),

            Expanded(
              child: ListView.builder(
                  itemCount: songs.length,
                  itemBuilder: (context , index) => BuildSongTileItem(
                      song: songs[index],
                      songs: songs
                  )
              ),
            )
          ],
        ),
      ),
    );
  }
}
