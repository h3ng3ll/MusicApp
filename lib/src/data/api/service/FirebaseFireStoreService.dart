// ignore_for_file: file_names



import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:music_app/src/data/api/model/ApiCurrentUser.dart';
import 'package:music_app/src/data/api/model/ApiCurrentUserPrivate.dart';
import 'package:music_app/src/data/api/model/ApiCurrentUserPublic.dart';
import 'package:music_app/src/data/api/model/ApiLibrary.dart';
import 'package:music_app/src/data/api/model/ApiNetworkSong.dart';
import 'package:music_app/src/data/api/service/FirebaseAuthService.dart';
import 'package:music_app/src/domain/model/Album.dart';
import 'package:music_app/src/domain/model/Library.dart';
import 'package:music_app/src/domain/model/song/NetworkSong.dart';
import 'package:music_app/src/domain/model/databases/Database.dart';
import 'package:music_app/src/domain/repository/Producer.dart';
import 'package:music_app/src/domain/model/CurrentUser.dart';


class FirebaseFireStoreService extends Database{



  //// START core
  static  FirebaseFireStoreService _instance ()  => FirebaseFireStoreService._internal();

  factory FirebaseFireStoreService() => _instance();

  FirebaseFireStoreService._internal();


  final FirebaseFirestore _fbInstance = FirebaseFirestore.instance;

  String? get   id =>  FirebaseAuthService.user?.uid;

  /// User
  DocumentReference<Map<String, dynamic>>  _userIdDoc  ({String? otherID}) =>  _fbInstance.collection("users").doc(otherID ?? id);

  DocumentReference<Map<String, dynamic>>  _publicDoc ({String? otherID}) =>  _userIdDoc(otherID: otherID ?? id).collection("public").doc("about");
  DocumentReference<Map<String, dynamic>>  _privateDoc  ({String? otherID}) =>  _userIdDoc(otherID: otherID ?? id).collection("private").doc("about");
  DocumentReference<Map<String, dynamic>>  _privateLibraryDoc ({String? otherID}) =>  _userIdDoc(otherID: otherID ?? id).collection("private").doc("library");
  DocumentReference<Map<String, dynamic>>  _privateEtcDoc ({String? otherID}) =>  _userIdDoc(otherID: otherID ?? id).collection("private").doc("etc");


  /// Songs Videos

  DocumentReference<Map<String, dynamic>> get _songDoc  =>  _fbInstance.collection("SongsVideos").doc("songs");

  CollectionReference<Map<String,  dynamic>> get _allSongsCol  =>  _songDoc.collection("all");
  CollectionReference<Map<String,  dynamic>> get _popularSongsCol  =>  _songDoc.collection("popular");







  ///
  /// [ END_CORE]
  ///

  /// return private and public information
    /// about User


  Future<List<NetworkSong>> intIdsToSongs (List<int> idS) async {
    final col = await _allSongsCol.get();
    List<NetworkSong> newSongList = [];

    for (var element in idS) { newSongList.add( await ApiNetworkSong.fromJson(col.docs[element - 1].data()));}

    return newSongList;
  }


   @override
  Future<CurrentUser> fetchCurrentUser () async {
     final publicDates  = await _publicDoc().get();
     final privateDates  = await _privateDoc().get();

     Map<String , dynamic> userMap () => {
       ...publicDates.data()!,
       ...privateDates.data()!
     };

     final cUser = await ApiCurrentUser.fromJson(userMap());

     return  cUser;
   }

  /// fetch all available songs in the database
  Future<List<NetworkSong>> fetchAllSongs () async {

    final col = await _allSongsCol.get();

    return await Stream.fromIterable(col.docs).asyncMap((event) => ApiNetworkSong.fromJson(event.data())).toList();
  }

  Future<List<NetworkSong>> fetchPopularSongs () async {
    QuerySnapshot<Map<String, dynamic>> popularSongs = await _popularSongsCol.get();

    /// id of docs equals the id of song
    final a =  popularSongs.docs.map((element) => {
        int.parse(element.id) : element.data()['playedTimes']
      }
     ).toList();

    /// song id || document id : played Times
    a..sort((a , b) => a.values.first.compareTo(b.values.first))..take(5);


    /// fetch all songs

    final col = await _allSongsCol.get();
    /// pop IDs
    final values = popularSongs.docs.map((e) => e.id).toList();
    /// take from all songs only if it stored in pop doc

    final docs = await Stream.fromIterable(col.docs.where((element) =>
        values.contains(element.id))).asyncMap((event) =>
        ApiNetworkSong.fromJson(event.data()) ).toList();

    return docs;
  }

  ///
  /// [ Firebase ] , [ Account] settings
  ///

  /// Initial writes to new user
  Future<void> signUpUserInitSetUp (CurrentUser user) async {
     ///  prevent appear of virtual document
    await _userIdDoc().set({});
    await _publicDoc().set(ApiCurrentUserPublic.toJson(user));
    await _privateDoc().set(ApiCurrentUserPrivate.toJson(user));

  }

  /// It is used for alternative  authorization user instead of user's email.
  Future<String?> findEmailByUserName (String username) async{

    String? email;

    final usersCol = await  _fbInstance.collection("users").get();

    final idS = usersCol.docs.map((e) => e.id);

    for (var element in idS) {
      final  data = await _userIdDoc(otherID: element).collection("public").doc("about").get();

      
      final possUser = data.data()!['userName'];
      
      if(username == possUser){
        /// user  found !
        email = data.data()!['email']; break ;
      }

    }


    return email;

  }

  Future<void> updateUsersCredentials (CurrentUser user) async =>
     await _publicDoc().update(ApiCurrentUser.toJson(user));

  Future<bool> checkAvailableUserName(String userName) async {
    final usersCol = await  _fbInstance.collection("users").get();

    for (var doc  in usersCol.docs){
      final  data = await _userIdDoc(otherID: doc.id).collection("public").doc("about").get();
      if(data.data()!['userName'] == userName){
        /// username already taken by  another user .
        return Future.value(false);
      }
    }
    /// username is free to use it .
    return true;
  }

  ///
  /// [Firestore] . [Library]
  ///


  /// store new [ $id ] of song
  Future<void> changeFavoriteSongs(List<NetworkSong> favorites) async {

    _privateLibraryDoc().update({
      "favorites" : favorites.map((e) => e.id).toList()
    });
  }



  Future<List<NetworkSong>> fetchRecentlyPlayedSong() async {
    final library = await _privateLibraryDoc().get();
    final  recentlyPlayedSongs =  List<int>.from(library.data()?['recentlyPlayedSongs']);
    return await intIdsToSongs(recentlyPlayedSongs);
  }

  Stream<Library?> libraryStream () async* {
    await for (var snapshot in _privateLibraryDoc().snapshots() ){
      yield await ApiLibrary.fromJson(snapshot.data()!);
    }
  }

  /// result of returning is list
  /// of id songs that  added
  /// to history
  Future<List<int>> fetchSongSearchHistory () async {
    try {
      final idsDS = await _privateEtcDoc().get();

      final List<dynamic>? ids = idsDS.data()?['searchHistory'];

      return ids != null ? List<int>.from(ids) : [] ;
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  Future<void> updateHistorySongs (List<int> ids) async {
    try {
      await _privateEtcDoc().update({
        "searchHistory" : ids
      });
    } on Exception catch ( e) {
      if((e as FirebaseException).code == "not-found"){
        await _privateEtcDoc().set({
          "searchHistory" : ids
        });
      }else {
        throw Exception(e);
      }

    }
  }

  Future<void> removeHistorySongs() async {
    try {
      await _privateEtcDoc().update({
        "searchHistory" : []
      });
    } on Exception catch (e) {
      throw Exception(e);
    }
  }



  Future<Producer> fetchProducerById(String uid ,) async {
      final userDoc  = await _publicDoc(otherID: uid).get();

      return Producer.fromJson(userDoc.data()!['compositor']);
  }

  Future<void> followUser(List<String> uids) async {
    await _publicDoc().update({
      "following" : uids
    });
  }

  Future<List<Album>> getAlbumsOfProducer(String uid) async {
    final doc = await  _publicDoc(otherID: uid).get();

    final albumList = (doc.data()!['band']['albums'] as List<dynamic>) ;

    final albums  = await Stream.fromIterable(albumList).asyncMap((e) => Album.fromJson(e as Map<String , dynamic>)).toList();
    return albums;
  }

}