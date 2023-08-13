// ignore_for_file: file_names




import 'dart:convert';

import 'package:music_app/src/data/api/model/ApiNetworkSong.dart';
import 'package:music_app/src/domain/model/song/LocalSong.dart';
import 'package:music_app/src/domain/model/song/NetworkSong.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  
  static Future _saveData(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is int) {
      prefs.setInt(key, value);
    } else if (value is double) {
      prefs.setDouble(key, value);
    } else if (value is String) {
      prefs.setString(key, value);
    } else if (value is bool) {
      prefs.setBool(key, value);
    } else if (value is List<String>) {
      prefs.setStringList(key, value);
    }
    else {
      throw Exception("Trying save data to LocalStorage with Invalid type");
    }
  }

  /// This method use only for network songs
  static Future<void> saveSongToHistory(NetworkSong song) async {
    final oldHistory = await restoreSongFromHistory();
    /// last 10 item only
    final historyList = [...oldHistory , song].reversed.toSet().toList().take(10);

    final decodedJson = historyList.map((NetworkSong e) => jsonEncode(ApiNetworkSong.toJson(e))).toList();
    await _saveData("historyPlayedSongs5", decodedJson);
  }

  static Future<List<NetworkSong>> restoreSongFromHistory() async {
    final pref = await SharedPreferences.getInstance();
    final List<String>? encodedSongs = pref.getStringList("historyPlayedSongs5");

    if(encodedSongs == null) return [];

    return  await Stream.fromIterable(encodedSongs).asyncMap((event) => ApiNetworkSong.fromJson(jsonDecode(event)) ).toList();
    // return encodedSongs.map((e) => ApiNetworkSong.fromJson(jsonDecode(e))).toList();

  }


  ///
  /// [Equalizer] variables
  ///

  static Future<Map<String , dynamic>?> restoreCenterBandFreqsCache () async {
    final pref = await SharedPreferences.getInstance();
    final String? encodedBands = pref.getString("CenterBandFreqsCache");

    if(encodedBands == null) return null;

    final list = jsonDecode(encodedBands ) as Map<String,dynamic>;
    return list ;
  }

  static Future<void> saveCenterBandFreqsCache (Map<String , dynamic> bands) async {
    // final pref = await SharedPreferences.getInstance();
    final encodedBands = jsonEncode(bands);

    await _saveData("CenterBandFreqsCache", encodedBands);
  }

  static Future<bool?> restoreEqualizerStatus() async {
    final pref = await SharedPreferences.getInstance();
    final status = pref.getBool("EqualizerStatus");
    return  status;
  }

  static Future<void> saveEqualizerStatus(bool status) async =>
    await _saveData("EqualizerStatus", status);


  static Future<void> savePresetName(String presetName) async =>
      await _saveData("presetName", presetName);

  static Future<String?> restorePresetName() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString("presetName");
  }

  static saveLocalLikedSong(LocalSong song) async {

    final songsMap = song.toJson();

    final encodedSongs = jsonEncode(songsMap);

    final pref = await SharedPreferences.getInstance();

    final restoredEncodedSongs = pref.getStringList("LocalLikedSong");

    final newSaveData = [...?restoredEncodedSongs , encodedSongs];

    await _saveData("LocalLikedSong", newSaveData);
  }

  static Future<List<LocalSong>?> restoreLocalLikedSong() async {
    final pref = await SharedPreferences.getInstance();
    final encodedSongs =  pref.getStringList("LocalLikedSong");

    if(encodedSongs == null) return null;

    final songs = encodedSongs.map((e) => LocalSong.fromJson(
        jsonDecode(e) as Map<String , dynamic>)).toList();

    return songs ;

  }

  static Future<List<LocalSong>?> restoreCachedLocalSongs() async {
    final pref = await SharedPreferences.getInstance();
    final encodedSongs =  pref.getStringList("CachedLocalSongs");

    if(encodedSongs == null) return null;

    final songs = encodedSongs.map((e) => LocalSong.fromJson(
        jsonDecode(e) as Map<String , dynamic>)).toList();

    return songs ;
  }


  static Future<void> saveCachedLocalSongs(List<LocalSong> songs) async {
    final encodedSongs = songs.map((song) => jsonEncode(song.toJson())).toList();
    await _saveData("CachedLocalSongs", encodedSongs);
  }


}