// ignore_for_file: file_names



import 'package:music_app/src/data/api/service/FirebaseFireStoreService.dart';
import 'package:music_app/src/domain/model/song/LocalSong.dart';
import 'package:music_app/src/domain/model/song/NetworkSong.dart';
import 'package:music_app/src/domain/repository/Producer.dart';
import 'package:music_app/src/local/services/LocalStorageService.dart';

class SongsRepository {

  ///
  /// [ Domain ]
  ///

  static Future<List<NetworkSong>> fetchPopularSongs () async =>
      FirebaseFireStoreService().fetchPopularSongs();

  ///  [ Producer ]  FireStore docs.
  static Future<Producer> fetchProducerById (String uid ) async =>
      FirebaseFireStoreService().fetchProducerById(uid);

  static Future<void> followUser(List<String> uid ) async =>  FirebaseFireStoreService().followUser(uid);



  ///
  ///  [ Locale ]
  ///

  static Future<void> saveSongToHistory( NetworkSong song) async =>
      LocalStorageService.saveSongToHistory(song);

  static Future<List<NetworkSong>> fetchSongFromHistory() async =>
      LocalStorageService.restoreSongFromHistory();


  static void saveLocalLikedSong(LocalSong song) async =>
      LocalStorageService.saveLocalLikedSong(song);

  static Future<List<LocalSong>?> fetchLocalLikedSong() async =>
      await  LocalStorageService.restoreLocalLikedSong();

  static Future<List<LocalSong>?> restoreCachedLocalSongs() async =>
      await  LocalStorageService.restoreCachedLocalSongs();

 static Future<void> saveCachedLocalSongs(List<LocalSong> songs) async =>
      await  LocalStorageService.saveCachedLocalSongs(songs);



}