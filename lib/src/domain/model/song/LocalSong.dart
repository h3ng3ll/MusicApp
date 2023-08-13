// ignore_for_file: file_names



import 'dart:io';

import 'package:music_app/src/domain/model/Album.dart';
import 'package:music_app/src/domain/repository/Song.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'dart:typed_data';

// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart' show getTemporaryDirectory;

class LocalSong extends Song {

  late final String artist ;
  late final String composer ;

  Uint8List? coverCacheData ;
  Map? map ;

  LocalSong( {
    required int id,
    String? composer ,
    String?  artist,
    required String songName,
    required Uri songURI,
    Album? album,
    Uri? coverUri,
    String? genre,
    this.coverCacheData,
    bool? isLiked ,
  }) : super(
      id: id,
      songName: songName,
      coverUri: coverUri,
      songURI: songURI,
      album: album,
      genre: genre,
      isLiked: isLiked,
  ) {
    this.composer = composer ?? "";
    this.artist = artist ?? "";
  }

  /// Convert songs from [LocalStorage ]
  /// by default try to convert Artist and song if
  /// it matching by pattern .
  static Future<LocalSong> fromSongModel (SongModel song , [bool parseItself = true]) async {

    String? artist  ;
    String? name  ;

    if(parseItself) {
      final regExp = RegExp(r".+\s?- ");


      final split  = song.displayNameWOExt.split(regExp);
      if(split.length == 1 ) {
        name = song.displayNameWOExt;
        artist = song.artist;

      }else {
        name = split[1];
        artist = song.displayNameWOExt.substring(0 , song.displayNameWOExt.length-split[1].length-2 );
      }
    }

    final coverBytes = await  OnAudioQuery().queryArtwork(song.id,  ArtworkType.AUDIO);

    final Uri? coverUri = coverBytes != null ? await _convertUint8ListToUri(coverBytes , song.displayNameWOExt) : null;

    return LocalSong(
        artist: artist ?? song.artist,
        songName: name ?? song.displayNameWOExt,
        songURI: Uri.parse(song.uri!),
        album: Album(name: song.album),
        genre: song.genre,
        composer: song.composer,
        id: song.id,
        coverUri:  coverUri,
        coverCacheData: coverBytes

    );
  }

  static Future<Uri> _convertUint8ListToUri(Uint8List data , String filename) async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;

    File tempFile = File('$tempPath/$filename');
    await tempFile.writeAsBytes(data);

    Uri uri = tempFile.uri;
    return uri;
  }


  Map<String , dynamic> toJson () => {
    "id" : id,
    "composer" : composer,
    "artist" : artist,
    "songName" : songName,
    "songURI" : songURI.toString(),
    "album" : album?.toJson(),
    "coverUri" : coverUri.toString(),
    "genre" : genre,
    "coverCacheData" : coverCacheData?.toList(),
    "isLiked" : isLiked,
  };

  static LocalSong fromJson (Map<String , dynamic> json) => LocalSong(
      id: json['id'],
      composer: json['composer'],
      artist:   json['artist'],
      songName: json['songName'],
      songURI: Uri.tryParse(json['songURI'])!,
      // album:  Album.fromJson(json['album']),
      coverUri:  Uri.tryParse(json['coverUri']),
      genre:  json['genre'],
      coverCacheData:  json['coverCacheData'] != null ? Uint8List.fromList(List<int>.from(json['coverCacheData'])) : null,
      isLiked:  json['isLiked']
  );
}