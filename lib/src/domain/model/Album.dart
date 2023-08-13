// ignore_for_file: file_names


import 'package:music_app/src/data/api/service/FirebaseFireStoreService.dart';
import 'package:music_app/src/domain/model/song/NetworkSong.dart';

/// Describe album of song
class Album {

  final String? name ;
  final String? createdTime;

  /// path of  album cover
  final String? coverPath;

  final List<NetworkSong> songs;

  Album({
    List<NetworkSong>? songs,
    this.coverPath,
    this.name,
    this.createdTime
  }) : songs = songs ?? [];

  static Future<Album> fromJson (Map<String , dynamic>json) async => Album(
    name: json['name'],
    createdTime: json['createdTime'],
    coverPath: json['coverPath'],
    /// songs ID
    songs: json['songs'] != null ?  await  FirebaseFireStoreService().intIdsToSongs(List<int>.from(json['songs']))  : [],
  );

  Map<String , dynamic> toJson () => {
    "name" : name,
    "createdTime" : createdTime,
    "coverPath" : coverPath,
  };

}