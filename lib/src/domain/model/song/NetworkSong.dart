// ignore_for_file: file_names



import 'package:equatable/equatable.dart';
import 'package:music_app/src/domain/model/Album.dart';
import 'package:music_app/src/domain/repository/Producer.dart';

import 'package:music_app/src/domain/repository/Song.dart';


class NetworkSong  extends Song with EquatableMixin  {

  final Producer producer ;

  NetworkSong({
    bool?  isLiked,
    required int id,
    required this.producer,
    required String songName,
    Uri? coverUri,
    Album? album,
    String? genre,
    required Uri songURI,
  }) : super(
      coverUri:  coverUri,
      id: id,
      songName:  songName,
      isLiked:  isLiked,
      genre: genre,
      songURI: songURI
  );


  String get searchFormat => "${producer.producerName} - $songName";

  @override
  List<Object> get props => [id];



}




