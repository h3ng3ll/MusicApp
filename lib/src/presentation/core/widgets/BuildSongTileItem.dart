// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:music_app/src/data/provider/LibraryProvider.dart';
import 'package:music_app/src/domain/model/song/LocalSong.dart';
import 'package:music_app/src/domain/repository/Song.dart';
import 'package:music_app/src/presentation/UI/Screens/Home/ShareScreen/MusicAudioPlayerScreen/MusicAudioPlayerScreen.dart';
import 'package:music_app/src/presentation/core/widgets/BuildAssetIcon.dart';
import 'package:music_app/src/presentation/core/widgets/BuildAvatarImage.dart';
import 'package:music_app/src/domain/model/song/NetworkSong.dart';
import 'package:music_app/src/data/provider/AudioProvider.dart';
import 'package:music_app/src/presentation/service/ColorService.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';


class BuildSongTileItem extends StatefulWidget {
  
  const BuildSongTileItem({
    Key? key,
    required this.song,
    required this.songs,
    this.onTap,
  }) : super(key: key);

  final Song song ;
  final List<Song> songs;
  final  Function()? onTap ;
  @override
  State<BuildSongTileItem> createState() => _BuildSongTileItemState();
}

class _BuildSongTileItemState extends State<BuildSongTileItem> {

  final double size = 80.0 ;

  void onTap (AudioProvider audio , BuildContext context ) {

    if(widget.onTap != null) widget.onTap!();

    final libraryProvider = Provider.of<LibraryProvider>(context ,listen: false);
    PersistentNavBarNavigator.pushDynamicScreen(
        context,
        withNavBar: false,
        screen: MaterialPageRoute(
            builder: (context) => MultiProvider(
              providers: [
                ChangeNotifierProvider<LibraryProvider>.value(value: libraryProvider),
                ChangeNotifierProvider.value(value: audio,)
              ],
              child: ChangeNotifierProvider.value(
                value: audio,
                child: MusicAudioPlayerScreen(
                  song: widget.song ,
                  songs: widget.songs ,
                  // index: widget.songs.indexOf(widget.song)
                ),
              ),
            )
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    final audio = Provider.of<AudioProvider>(context);


    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: InkWell(
        onTap: () => onTap(audio, context),
        child: Row(
          children: [

          Expanded(
              flex: 15,
              child: buildCover()
          ) ,

            /// Undead Corptoration
            /// Xing Noises
            Expanded(
              flex: 20,
                child: buildSongsMeta(context)
            ),

            const Spacer(),

            /// Play Pause
            Expanded(
                flex: 10,
                child: buildPlayButton()
            ),
            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }

  Widget buildCover() {

    if(widget.song is LocalSong) {
        return BuildAvatarImage(
          cache: (widget.song as LocalSong).coverCacheData ,
          width: size,
          height: size,
        );
    } else if (widget.song is NetworkSong ) {
      return buildSongsCover(path: widget.song.coverUri.toString());
    }
    else {
      return BuildAvatarImage.empty(
        boxFit: BoxFit.scaleDown,
        height: size,
        width: size,
      );
    }
  }

  Widget buildSongsCover ({String? path, Uint8List? cache}) {
    if(path != null) {
      return BuildAvatarImage(
        imgUrl: path,
        height: size,
        width: size,
        circularRadius: 15,
      );
    }

    return Image.memory(
        cache!,
    );
  }


  Widget buildSongsMeta (BuildContext context) {
    final  titleSmall = Theme.of(context).textTheme.titleSmall;

    final  labelSmall = Theme.of(context).textTheme.labelSmall?.
    copyWith(
        fontWeight: FontWeight.normal,
        shadows: [
          Shadow(
              offset: const Offset(1 , 0),
              color: grey.withOpacity(0.5)
          ),
          const Shadow(
              offset: Offset(3 , 0),
              color: black2,
              blurRadius: 2
          )
        ]
    );


    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.song is NetworkSong ? (widget.song as NetworkSong ).producer.producerName : (widget.song as LocalSong).artist ,
              style:  titleSmall,
              maxLines: 2,
              softWrap: true,
          ),
          const SizedBox(height: 8),
          Text(
            widget.song.songName,
            style: labelSmall,
            softWrap: true,
            maxLines: 3,
          ),

        ],
      ),
    );
  }

  Widget buildPlayButton () {
    final audio = Provider.of<AudioProvider>(context  , listen:  false);

    /// id of song equal to now playing .
    final isPlaying = audio.isPlaying && audio.id == widget.songs.indexOf(widget.song) && listEquals(widget.songs, AudioProvider.songs)  ;

    return InkWell(
      onTap: () async {
        AudioProvider.initialize(widget.songs);

        if(isPlaying){
          audio.pause();
        }
        else {
          if(widget.song is NetworkSong) {
            /// migrate by id
            await audio.moveTo((widget.song as NetworkSong).id);
            /// migrate by index if the list
          } else if (widget.song is LocalSong){
            await audio.moveTo((widget.song as LocalSong).id);
          }
          await AudioProvider.player.play();
        }
      } ,
      child: BuildAssetIcon(
          size: 40,
          iconName: isPlaying ? "pauseButton" : "playButton"
      )

    );
  }


}
