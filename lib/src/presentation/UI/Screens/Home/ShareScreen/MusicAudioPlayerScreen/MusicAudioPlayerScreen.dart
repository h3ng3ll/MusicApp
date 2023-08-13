// ignore_for_file: file_names


import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/src/data/bloc/AudioPlayerBloc/audio_player_bloc.dart';
import 'package:music_app/src/data/provider/AudioProvider.dart';
import 'package:music_app/src/domain/model/song/LocalSong.dart';
import 'package:music_app/src/domain/model/song/NetworkSong.dart';
import 'package:music_app/src/domain/repository/Song.dart';
import 'package:music_app/src/presentation/UI/Screens/Home/ShareScreen/MusicAudioPlayerScreen/MusicPlayerTabBarWidget/MusicPlayerTabBarWidget.dart';
import 'package:music_app/src/presentation/UI/Screens/Home/ShareScreen/MusicAudioPlayerScreen/widget/MusicActionsPanel.dart';
import 'package:music_app/src/presentation/UI/Screens/Home/ShareScreen/MusicAudioPlayerScreen/widget/BuildAddUserIcon.dart';
import 'package:music_app/src/presentation/UI/Screens/Home/ShareScreen/MusicAudioPlayerScreen/widget/MusicSliderBar.dart';
import 'package:music_app/src/presentation/UI/Screens/Home/ShareScreen/MusicAudioPlayerScreen/widget/SeekBar.dart';
import 'package:music_app/src/presentation/core/constants.dart' as s;
import 'package:music_app/src/presentation/core/widgets/BuildAssetIcon.dart';
import 'package:music_app/src/presentation/core/widgets/BuildAvatarImage.dart';
import 'package:music_app/src/presentation/service/OverlayService.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class MusicAudioPlayerScreen extends StatefulWidget {
  const MusicAudioPlayerScreen(
      {Key? key, required this.song, required this.songs}) : super(key: key);

  final Song song;

  final List<Song> songs;

  @override
  State<MusicAudioPlayerScreen> createState() => _MusicAudioPlayerScreenState();
}

class _MusicAudioPlayerScreenState extends State<MusicAudioPlayerScreen> {

  late final AudioPlayerBloc bloc ;

  void onWillPop() {
    bloc.add(ClosePlayerEvent());

    /// can be only 1 opened dialog i.e The 'Share Song' dialog
    if (OverlayService.overlayVisible) {
      OverlayService().closeOverlay();
    }
    final provider = Provider.of<AudioProvider>(context, listen: false);

    final isPlaying = provider.isPlaying;

    /// if some song is playing now  then
    /// dialog should be opened to monitor it .
    if(isPlaying) OverlayService().playerOverlay(context, song: widget.song);
  }

  @override
  void initState() {
    bloc = AudioPlayerBloc(widget.songs, widget.song);
    if (OverlayService.overlayVisible) {
      OverlayService().closeOverlay();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: WillPopScope(
          child: BlocProvider(
            create: (context) => bloc,
            child: BlocBuilder(
                bloc: bloc,
                builder: (context, state) {
                  if (state is AudioPlayerLoadedState) {
                    return buildUI(state.song);
                  }
                  if (state is AudioPlayerLoadingState) {
                    return const Center(child: CircularProgressIndicator(),);
                  }
                  else if (state is AudioPlayerInitialState) {
                    Future.delayed(const Duration(seconds: 3));
                    return const Center(child: CircularProgressIndicator(),);
                  }
                  throw Exception("Unhandled Player building");
                }
              // ),
            ),
          ),
          onWillPop: () async {
            onWillPop();
            return true;
          },
        ),
      ),
    );
  }

  Widget buildUI(Song song,) {
    final size = s.size(context);
    return Column(
      children: [
        SizedBox(height: size.height * 0.01,),

        /// \/                    O+
        /// \/                   000 
        ///                            
        buildBackButtonAndAddUser(size, song),

        Expanded(
            flex: 30,
            child: buildIconPreview(size, song)
        ),

        const Spacer(),


        /// DragonForce       ####
        ///   Fallen World    ####
        Expanded(
          flex: 10,
            child: buildMeta(size, song)
        ),

        const Spacer(flex: 2),

        /// 00:00 ------------ 04:08
        buildSongDuration(size,),
        const Spacer(flex: 2),

        /// 
        /// Shuffle Previous Play Next Repeat
        /// 
        Expanded(flex:  4 , child: MusicActionsPanel(song: song,)),

        const Spacer(flex: 2),

        MultiProvider(providers: [Provider<Song>.value(value: song),], child: const MusicPlayerTabBarWidget(),),

      ],
    );
  }




  Widget buildBackButtonAndAddUser(Size size, Song song) {
    final dynSize = size.height * 0.07;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () {
            onWillPop();
            Navigator.pop(context);
          },
          child: BuildAssetIcon(
              size: dynSize,
              iconName: "arrow_down"
          ),
        ),


        /// if [ Song ] from local user can't add it
        /// cause it feature provided from
        /// network song

        if(widget.song is NetworkSong) BuildAddUserIcon(dynSize: dynSize, song: song as NetworkSong,)
    
        

      ],
    );
  }

  Widget buildIconPreview(Size size, Song? changedSong) {
    final dynSize = size.height * 0.35;
    if(changedSong is NetworkSong) {
      return BuildAvatarImage(
        goldShadow: true,
        imgUrl: changedSong.coverUri?.toString() ,
        boxShadow: const [],
        padding: EdgeInsets.zero,
        boxFit: BoxFit.fill,
        //  _firstBoot ? widget.song.albumArt : changedSong?.albumArt ?? widget.song.albumArt,
        width: dynSize * 1.2,
        height: dynSize,
      );
    } else if  (changedSong is LocalSong) {
      return FutureBuilder<Uint8List?>(
        future: ( OnAudioQuery()).queryArtwork(
          changedSong.id,
          ArtworkType.AUDIO,
          size: (dynSize * 1.2).toInt(),
        ),
        builder: (context, item) {
          if (item.data != null && item.data!.isNotEmpty) {
            return BuildAvatarImage(
              cache: item.data! ,
              width: dynSize * 1.2,
              height: dynSize,
            );
          }
          return BuildAvatarImage.empty(
            boxFit: BoxFit.scaleDown,
            width: dynSize * 1.2,
            height: dynSize,
          );
        },
      );
    }
    return Container();

  }

  Widget buildMeta(Size size, Song song) {
    final titleMedium = Theme
        .of(context)
        .textTheme
        .titleMedium;
    final titleSmall = Theme
        .of(context)
        .textTheme
        .labelMedium;

    final dynSize = size.height * 0.2;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: FittedBox(
              fit: BoxFit.fitHeight,

              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    song is NetworkSong ? (song.producer.producerName ): (song as LocalSong).artist ,
                    style: titleMedium?.copyWith(fontSize: 30),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    width: size.width/2,
                    child: Text(
                      song.songName,
                      style: titleSmall,
                      textAlign: TextAlign.center,
                      // softWrap: true,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            flex: 2,
            child: BuildAvatarImage(
              imgUrl: song is NetworkSong ? song.producer.avatarUrl : null,
              shape: BoxShape.circle,
              width: dynSize,
              height: dynSize,
              cache:  song is LocalSong ? song.coverCacheData : null
            ),
          )

        ],
      ),
    );
  }

  Widget buildSongDuration(Size size) {
    return StreamBuilder<PositionData>(
        stream: AudioProvider.positionDataStream,
        builder: (context, snapshot) {
          final positionData = snapshot.data;
          return MusicSliderBar(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
            duration: positionData?.duration ?? Duration.zero,
            position: positionData?.position ?? Duration.zero,
            bufferedPosition: positionData?.bufferedPosition ?? Duration.zero,
            onChanged: (position) {
              AudioProvider.player.seek(position);
            },
          );
        }
    );
  }

}
