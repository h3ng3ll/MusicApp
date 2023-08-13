part of 'audio_player_bloc.dart';

@immutable
abstract class AudioPlayerEvent {}


class PlaySongEvent extends AudioPlayerEvent{
  final List<Song> songs ;
  final Song song;

  PlaySongEvent(this.songs, this.song);
}
class PlayNextSongEvent extends AudioPlayerEvent{}
class PlayPreviousSongEvent extends AudioPlayerEvent{}


class LoadSongEvent  extends AudioPlayerEvent{}

class LikeSongEvent extends AudioPlayerEvent{
  final Song song ;

  LikeSongEvent({required this.song});
}



class FollowUserEvent extends AudioPlayerEvent{

  final List<String> uids;

  FollowUserEvent({required this.uids});
}

/// cancel stream subscription to get
/// new songs.
class ClosePlayerEvent  extends AudioPlayerEvent{}
