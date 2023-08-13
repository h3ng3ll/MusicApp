// ignore_for_file: file_names


import 'package:music_app/src/data/api/model/ApiNetworkSong.dart';
import 'package:music_app/src/domain/model/song/NetworkSong.dart';

class ConverterService {
  static  Future<List<NetworkSong>> convertFromIdToSong (List<dynamic>? api) async {
    return api != null ?
    await Stream.fromIterable(api ).asyncMap((event) => ApiNetworkSong.fromJson(event)).toList() : [];
  }
}