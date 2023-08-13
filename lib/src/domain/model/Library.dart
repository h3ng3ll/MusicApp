// ignore_for_file: file_names


import 'package:music_app/src/domain/model/Album.dart';
import 'package:music_app/src/domain/repository/Producer.dart';
import 'package:music_app/src/domain/repository/Song.dart';

/// Describe the storage of
/// musics or videos of
/// current user .
class Library   {

   late  List<Album> albums ;
   late  List<Song> playlists ;
   late  List<Song> musicVideos ;
   late  List<Song> favorites ;
   late  List<Song> songs ;
   late  List<int> recentlyPlayedSongs ;
   late List<Producer> producers;

   Library ({
       List<Album>? albums ,
       List<Song>? playlists ,
       List<Song>? musicVideos ,
       List<Song>? songs ,
       List<Song>? favorites ,
       List<int>? recentlyPlayedSongs ,
       List<Producer>? producers,
   }) :   albums =  (albums ?? []) ,
          musicVideos =  (musicVideos ?? []) ,
          songs =  (songs ?? []) ,
          favorites =  (favorites ?? []) ,
          recentlyPlayedSongs =  (recentlyPlayedSongs ?? []) ,
          producers =  (producers ?? []) ,
          playlists =  (playlists ?? []);

}