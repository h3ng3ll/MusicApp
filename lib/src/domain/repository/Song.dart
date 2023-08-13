// ignore_for_file: file_names


import 'package:music_app/src/domain/model/Album.dart';

abstract class Song{

  String? genre ;

  /// if song has unique
  /// cover of song it
  /// won't  be empty
  Uri? coverUri;


  final String songName ;
  final Album? album ;

  final int id ;

  final Uri songURI ;
  /// Field is [ False ] if
  /// not specify directly

  bool isLiked ;

  Song({
    required this.id,
    this.coverUri ,
    required this.songURI,
    required this.songName ,
    this.album,
    this.genre,
    bool? isLiked ,
  }) : isLiked = isLiked ?? false;

}