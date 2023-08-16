// ignore_for_file: file_names


// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:equalizer_flutter/equalizer_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/src/data/provider/LibraryProvider.dart';
import 'package:music_app/src/domain/model/song/LocalSong.dart';
import 'package:music_app/src/domain/model/song/NetworkSong.dart';
import 'package:music_app/src/domain/repository/Song.dart';
import 'package:music_app/src/local/services/LocalStorageService.dart';
import 'package:music_app/src/presentation/UI/Screens/Home/ShareScreen/MusicAudioPlayerScreen/widget/SeekBar.dart';
import 'package:rxdart/rxdart.dart';

class AudioProvider extends ChangeNotifier {


  static final AudioPlayer _player =  AudioPlayer(audioPipeline: AudioPipeline(androidAudioEffects: [AndroidLoudnessEnhancer()]));

  static AudioPlayer get player => _player ;


  static ConcatenatingAudioSource?  playlist;

  MediaItem? get activePlaylistSong => id != null ? playlist?.sequence[id!].tag : null;

  static final StreamController<Song> activeSongStreamController = StreamController<Song>();

  static final Stream<Song> activeSongStream = activeSongStreamController.stream.asBroadcastStream();

  static Song get activeSong => _activeSong;

  static late Song _activeSong ;
  /// id of song currently active

  static List<Song>? songs  ;

  int? _id ;
  int? get id => _id;

  bool isPlaying = false;
  bool loopMode  = false;

  static List<String> storedIDSongsToPlayer = <String>[];

  /// equalizer settings
  bool _enabledEQ = false;

  bool get enabledEQ => _enabledEQ;

  set  enabledEQ (bool value) {
     _enabledEQ = value;
     notifyListeners();
  }

  AudioProvider(BuildContext context){
    init();
    streamHandling();
  }
  void init() async {
    EqualizerFlutter.init(player.androidAudioSessionId ?? 0);
    _enabledEQ = await LocalStorageService.restoreEqualizerStatus() ?? false;
    EqualizerFlutter.setEnabled(_enabledEQ);
  }
  void streamHandling () {
    player.playerStateStream.listen((event) {
      if(isPlaying != event.playing){
        isPlaying  = event.playing;
        notifyListeners();
      }
      else if (event.processingState == ProcessingState.completed){
        player.seekToNext();
      }
    });

    player.currentIndexStream.listen((id) {
      if(id != null) {
        _id = id;
        notifyListeners();
      }
    });

    AudioProvider.player.currentIndexStream.listen((index) {
      if(songs == null) return ; /// songs haven't initialized yet .
      _activeSong = songs![index ?? 0];
      activeSongStreamController.add(_activeSong);
    });
  }


   static ConcatenatingAudioSource initialize(List<Song> songs , [int? id]) {
    AudioProvider.songs = songs;
    final playlist = ConcatenatingAudioSource(
        children: songs.map((song) {
          if(song is NetworkSong) {
            return AudioSource.uri(
                song.songURI,
                tag: MediaItem(
                    id: song.id.toString(),
                    title: song.songName,
                    artist: song.producer.producerName,
                    artUri: song.coverUri
                )
            );
          }else if (song is  LocalSong){
            return AudioSource.uri(
                song.songURI,
                tag: MediaItem(
                    id: song.id.toString(),
                    title: song.songName,
                    artist: song.artist,
                    artUri: song.coverUri
                    // artUri: a
                )
            );
          }
          else {
            throw Exception("Invalid type of object Song");
          }

        }).toList()
    );

    final activeIDsSongs = playlist.children.map((e) => ((e as UriAudioSource ).tag as MediaItem).id).toList();

    if(!listEquals(activeIDsSongs , storedIDSongsToPlayer)){
      AudioProvider.playlist = playlist;
      player.setAudioSource(playlist);
      AudioProvider.storedIDSongsToPlayer = activeIDsSongs;
    }

     return playlist;
  }

  void next () async => await player.seekToNext();

  void previous ( ) async => await player.seekToPrevious();

  Future<void> moveTo ( int songId)  async {
    final index = storedIDSongsToPlayer.indexOf(songId.toString());

    /// take index of playlist NOT MediaItem index !
   await  player.seek(Duration.zero , index: index);
  }

  Future<void>  pause () async => await player.pause();

  Future<void>  play (Song? song) async {
    if(song is NetworkSong){
      LibraryProvider.recentlyPlayedSongController.add(song);
    }
    await player.play();
  }

  Future<void> switchShuffleMode () async {
    final mode = !player.shuffleModeEnabled;
    player.setShuffleModeEnabled(mode);
    if(mode){
      await player.shuffle();
    }

  }
  void toggleLoopMode () async {

    loopMode = !loopMode;
    loopMode ? player.setLoopMode(LoopMode.one) :
                player.setLoopMode(LoopMode.all);
  }

  static Stream<PositionData> get positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          player.positionStream,
          player.bufferedPositionStream,
          player.durationStream,
              (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));


}