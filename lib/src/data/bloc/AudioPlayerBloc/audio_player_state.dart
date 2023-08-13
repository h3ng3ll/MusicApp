part of 'audio_player_bloc.dart';

@immutable
abstract class AudioPlayerState {}

class AudioPlayerInitialState extends AudioPlayerState {

  final List<Song> songs ;
  final Song song;
  final AudioPlayer player ;


  bool hasPlaylistChanged(ConcatenatingAudioSource playlist) {
    return !listEquals(
        player.audioSource?.sequence.map((e) => e.tag.id).toList() ,
        playlist.sequence.map((e) => e.tag.id).toList());
  }

  bool theSameSong (ConcatenatingAudioSource playlist) {

    if(player.sequence == null) return true;

    final playerIndex = player.currentIndex;
    if(playerIndex == null) return true;
    return songs[playerIndex] != song;
  }

  void reSignSong (ConcatenatingAudioSource playlist) {
    final index = songs.map((e) => e.id).toList().indexOf(song.id);

    player.setAudioSource(
        playlist ,
        initialIndex: index
    );

    player.play();

    /// add to history playlist
    if(song is NetworkSong) {
      LibraryProvider.recentlyPlayedSongController.sink.add(song as NetworkSong);
    }

  }

  AudioPlayerInitialState(this.songs, this.player, this.song)  {


    final playlist = AudioProvider.initialize(songs);
    // final playlist = ConcatenatingAudioSource(
    //     children: songs.map((song) {
    //       if(song is NetworkSong) {
    //         return AudioSource.uri(
    //             song.songURI,
    //             tag: MediaItem(
    //                 id: song.id.toString(),
    //                 title: song.songName,
    //                 artist: song.producer.producerName,
    //                 artUri: song.coverUri
    //             )
    //         );
    //       }else if (song is  LocalSong){
    //         return AudioSource.uri(
    //             song.songURI,
    //             tag: MediaItem(
    //                 id: song.id.toString(),
    //                 // id: songs.indexOf(song).toString(),
    //                 title: song.songName,
    //                 artist: song.artist,
    //                 artUri: song.coverUri
    //             )
    //         );
    //       }
    //       else {
    //         throw Exception("Invalid type of object Song");
    //       }
    //
    //     }).toList()
    // );

      /// resign playlist
      if(hasPlaylistChanged(playlist) || theSameSong(playlist) ) reSignSong(playlist);


    }
}

class AudioPlayerLoadingState extends AudioPlayerState {}

class AudioPlayerLoadedState extends AudioPlayerState {
  
  final Song song ;
  AudioPlayerLoadedState(this.song);
}

// class  AudioPlayerLikeSongState extends AudioPlayerState {
//
// }