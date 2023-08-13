// ignore_for_file: file_names



import 'package:music_app/src/data/api/service/FirebaseFireStoreService.dart';
import 'package:music_app/src/domain/model/Album.dart';
import 'package:music_app/src/domain/model/CurrentUser.dart';
import 'package:music_app/src/domain/model/Library.dart';
import 'package:music_app/src/domain/model/song/NetworkSong.dart';


class UserRepository {

  static Future<CurrentUser> fetchCurrentUser () async =>
     await FirebaseFireStoreService().fetchCurrentUser();

  static Future<void> changeFavoriteSongs(List<NetworkSong>favorites) async{
    await FirebaseFireStoreService().changeFavoriteSongs(favorites);
  }

  /// stream of [Library] Dates
  static Stream<Library?> library () =>  FirebaseFireStoreService().libraryStream();


  ///
  ///  The History of Searched Songs
  ///

  static Future<List<int>> fetchSongSearchHistory () async =>  FirebaseFireStoreService().fetchSongSearchHistory();
  static Future<void> updateHistorySongs (List<int> ids) async =>  FirebaseFireStoreService().updateHistorySongs(ids);
  static Future<void> removeHistorySongs () async =>  FirebaseFireStoreService().removeHistorySongs();

  ///
  ///  Take id of the producer and
  ///  restoring albums that it added
  ///
  static Future<List<Album>> getAlbumsOfProducer(String uid) async =>
      await  FirebaseFireStoreService().getAlbumsOfProducer(uid);


}