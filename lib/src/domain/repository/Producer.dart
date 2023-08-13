// ignore_for_file: file_names


import 'package:music_app/src/data/api/model/ApiNetworkSong.dart';
import 'package:music_app/src/data/repository/SongsRepository.dart';
import 'package:music_app/src/data/repository/UserRepository.dart';
import 'package:music_app/src/domain/model/Album.dart';
import 'package:music_app/src/domain/model/song/NetworkSong.dart';
import 'package:music_app/src/domain/repository/User.dart';

/// class have properties of common User
/// it can add or store songs.
 class Producer extends User{

   final String producerName;
   late final  List<NetworkSong> songs;



  Producer({
    required String id ,
    String? avatarUrl,
    List<NetworkSong>? songs,
    required this.producerName,
  }) : super(id: id , avatarUrl: avatarUrl) {
    this.songs = songs ?? [];
  }

   static Producer fromJson(Map<String, dynamic> json) {
    return Producer(
      id: json['id'],
      avatarUrl: json['avatarUrl'],
      producerName: json['producerName'],
    );
  }

  static Future<Producer> fromUID (String uid) async  => await SongsRepository.fetchProducerById(uid);

   Map<String, dynamic> toJson() => {
    "id" : id,
    "avatarUrl" : avatarUrl,
    "producerName" : producerName,
    "songs" : songs.map((e) => ApiNetworkSong.toJson(e)).toList(),
  };


   Future<List<Album>> getAlbums () async {
     return await UserRepository.getAlbumsOfProducer(id);
   }
}