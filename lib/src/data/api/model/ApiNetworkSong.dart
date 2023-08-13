// ignore_for_file: file_names
import 'package:music_app/src/domain/model/song/NetworkSong.dart';
import 'package:music_app/src/domain/repository/Producer.dart';

class ApiNetworkSong {

  static Future<NetworkSong> fromJson(Map<String, dynamic> json) async {

    return NetworkSong(
      songName: json['songName'],
      producer: json['producer'] != null ?  Producer.fromJson(json['producer']) :  await Producer.fromUID(json['uid']),
      coverUri: Uri.tryParse(json['coverPath']),
      genre: json['genre'],
      songURI: Uri.parse(json['songURI']) ,
      id: json['id'],
      isLiked: json['isLiked'] ?? false,
    );
  }

  static Map<String , dynamic> toJson (NetworkSong song) => {
    "songName" : song.songName ,
    "producer" : song.producer.toJson(),
    "coverPath" : song.coverUri.toString() ,
    "id" : song.id ,
    "album" : song.album?.toJson(),
    "isLiked" : song.isLiked ,
    "songURI" : song.songURI.toString() ,
    "genre" : song.genre ,
  };
}
