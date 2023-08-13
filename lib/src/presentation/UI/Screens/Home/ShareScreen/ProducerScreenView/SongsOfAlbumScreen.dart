// ignore_for_file: file_names



import 'package:flutter/material.dart';
import 'package:music_app/src/domain/model/Album.dart';
import 'package:music_app/src/presentation/core/widgets/BuildSongTileItem.dart';

class SongOfAlbumScreen extends StatelessWidget {
  final Album album;
  const SongOfAlbumScreen({Key? key, required this.album}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Image.network(
              album.coverPath!,
              fit: BoxFit.cover,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: album.songs.map((song) => BuildSongTileItem(
                song: song,
                songs: album.songs
            )).toList(),
          ),
        ],
      ),
    );
  }
}
