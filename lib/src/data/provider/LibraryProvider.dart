// ignore_for_file: file_names



import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:music_app/src/data/repository/SongsRepository.dart';
import 'package:music_app/src/data/repository/UserRepository.dart';
import 'package:music_app/src/domain/model/Library.dart';
import 'package:music_app/src/domain/model/song/LocalSong.dart';
import 'package:music_app/src/domain/model/song/NetworkSong.dart';
import 'package:music_app/src/domain/repository/Song.dart';



class LibraryProvider extends ChangeNotifier {

  
  /// Contains such songs : albums ,
  /// favorites songs downloads and
  /// music videos . 

  static Library library = Library();

  /// controllers
  static StreamController<Song> likedSongController  =  StreamController();

  /// streams
  static Stream<NetworkSong> recentlyPlayedSongStream = recentlyPlayedSongController.stream;


  /// [ Local ]
  static Library localLibrary = Library();

  /// controllers

  static StreamController<NetworkSong> recentlyPlayedSongController  =  StreamController();
  /// streams

  static Stream<Song> likedSongStream  =  likedSongController.stream.asBroadcastStream();


  LibraryProvider () {
    initNetwork();
    initLocal();

    likedSongStream.listen((song) async {
      if(song is LocalSong){
        if(song.isLiked ) {
          localLibrary.favorites.add(song);
        } else {
          localLibrary.favorites.remove(song);
        }
        SongsRepository.saveLocalLikedSong(song );
      }else if (song is NetworkSong){
        if(song.isLiked ) {
          library.favorites.add(song);
        } else {
          library.favorites.remove(song);
        }
        await UserRepository.changeFavoriteSongs(library.favorites as List<NetworkSong>);
      }
    });

  }

  void initLocal() async {
    localLibrary.songs = await  SongsRepository.restoreCachedLocalSongs() ?? [];
    localLibrary.favorites = await  SongsRepository.fetchLocalLikedSong() ?? [];
  }

  /// listen all changes to library from FireBase docs .

  void initNetwork () async {
    UserRepository.library().listen((newLibrary) {
      if(newLibrary != null){
        library = newLibrary;
        notifyListeners();
      }
    });
    recentlyPlayedSongStream.listen((networkSong) {
      SongsRepository.saveSongToHistory(networkSong);
    });
  }



  static Future<void> updateLocalSongs (List<LocalSong> songs) async {
    localLibrary.songs = songs;
    await SongsRepository.saveCachedLocalSongs(songs);
  }


}