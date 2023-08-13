// ignore_for_file: invalid_use_of_visible_for_testing_member, depend_on_referenced_packages

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/src/data/provider/AudioProvider.dart';
import 'package:music_app/src/data/provider/LibraryProvider.dart';
import 'package:music_app/src/data/provider/UserProvider.dart';
import 'package:music_app/src/data/repository/SongsRepository.dart';
import 'package:music_app/src/domain/model/song/NetworkSong.dart';
import 'package:music_app/src/domain/repository/Song.dart';

part 'audio_player_event.dart';
part 'audio_player_state.dart';

class AudioPlayerBloc extends Bloc<AudioPlayerEvent, AudioPlayerState> {
  
  final List<Song> songs;
  final player = AudioProvider.player;
  final Song song  ;

  AudioPlayerBloc(this.songs, this.song) : super(AudioPlayerInitialState(songs , AudioProvider.player , song)) {


    final subscription = player.currentIndexStream.listen((int? index) {
      if(index != null)  emit(AudioPlayerLoadedState(songs[index]));
    });

    on<ClosePlayerEvent>((event , emit) async => await subscription.cancel());

    on<FollowUserEvent>((event , emit) async {
      final uids = event.uids;
      await SongsRepository.followUser(uids);
      UserProvider.user.following = uids;
      UserProvider.followingStreamController.sink.add(uids);
    });

    
    on<PlayNextSongEvent>((event ,emit) async{
      await player.seekToNext();
    });

    on<LoadSongEvent>((event ,emit) async{
      emit.call(AudioPlayerLoadedState(song));
    });


    on<PlayPreviousSongEvent>((event ,emit) async{
      await player.seekToPrevious();
    });

    on<LikeSongEvent>((event , emit) async {
      final song = event.song;
      song.isLiked = !song.isLiked;

      LibraryProvider.likedSongController.sink.add(song);
    });

     Future.delayed(const Duration(seconds: 1)).then((_) => emit(AudioPlayerLoadedState(song)));
  }



}
