// ignore_for_file: file_names


import 'package:music_app/src/data/api/service/ConverterService.dart';
import 'package:music_app/src/data/api/service/FirebaseFireStoreService.dart';
import 'package:music_app/src/data/repository/SongsRepository.dart';
import 'package:music_app/src/domain/model/Library.dart';
import 'package:music_app/src/domain/repository/Producer.dart';

class ApiLibrary {


  static _convertFromJsonToSong (dynamic api ) => ConverterService.convertFromIdToSong(api); 

  static Future<Library> fromJson (Map<String , dynamic> json) async {

    return Library(
      playlists: await _convertFromJsonToSong(json['playlists']),
      musicVideos: await _convertFromJsonToSong(json['musicVideos']),
      songs: await _convertFromJsonToSong(json['songs']),
      favorites: await FirebaseFireStoreService().intIdsToSongs(List<int>.from(json['favorites'])),
      recentlyPlayedSongs: json['recentlyPlayedSongs'] != null ? List<int>.from(json['recentlyPlayedSongs']) : [],
      producers: await _getProducers( json['producers'])
    );
  }


  static Future<List<Producer>> _getProducers(dynamic uids ) async {
    final List<Producer>  ret = [];
    final List<String> producers   = uids != null ? List<String>.from(uids) : [];

     for (var element in producers) {
      final producer = await SongsRepository.fetchProducerById(element);
      ret.add(producer);
     }
     return ret ;

  }

  Map<String , dynamic> toJson (Library library) => {
    "albums" : library.albums,
    "playlists" : library.playlists,
    "musicVideos" : library.musicVideos,
    "songs" : library.songs,
    "favorites" : library.favorites,
    "recentlyPlayedSongs" : library.recentlyPlayedSongs,
    "producers" : library.producers.map((e) => e.toJson()).toList()
  };
}