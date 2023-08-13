// ignore_for_file: file_names
// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:music_app/src/data/provider/AudioProvider.dart';
import 'package:music_app/src/data/provider/LibraryProvider.dart';
import 'package:music_app/src/domain/model/song/LocalSong.dart';
import 'package:music_app/src/domain/model/song/NetworkSong.dart';
import 'package:music_app/src/domain/repository/Song.dart';
import 'package:music_app/src/presentation/core/constants.dart';
import 'package:music_app/src/presentation/core/widgets/BuildAssetIcon.dart';
import 'package:music_app/src/presentation/service/ColorService.dart';
import 'package:music_app/src/presentation/service/OverlayService.dart';

/// The player bar appearing  when played song
/// has scrolled and it playing  simultaneously


class BuildPlayerOverLay extends StatefulWidget {

  Song song ;

  BuildPlayerOverLay({
    Key? key,
    required this.song,

  }) : super(key: key);


  @override
  State<BuildPlayerOverLay> createState() => BuildPlayerOverLayState();
}

class BuildPlayerOverLayState extends State<BuildPlayerOverLay>  with TickerProviderStateMixin{

  late final  AnimationController animationController ;
  late final Animation<double> animation ;

  late final  AnimationController opacityController ;
  late final Animation<double> animationOpacity ;

  bool isDragging = false;

  @override
  void initState() {
    const  milliseconds = 400;
    animationController = AnimationController(vsync: this , duration: const Duration(milliseconds: milliseconds));
    animation = CurveTween(curve: Curves.fastOutSlowIn ).animate(animationController);

    opacityController = AnimationController(vsync: this , duration: const Duration(milliseconds: milliseconds));
    animationOpacity = CurveTween(curve: Curves.fastOutSlowIn ).animate(opacityController);
    opacityController.animateTo(1);

    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    opacityController.dispose();
    super.dispose();
  }
  void onVerticalDragUpdate(DragUpdateDetails details ) {
    if(details.primaryDelta!  > 3.5) {
      isDragging = true;
    }
  }
  void onVerticalDragEnd (DragEndDetails details ) {
    if(isDragging) {
      if(animationController.isAnimating || animationController.status == AnimationStatus.completed ) return ;
      animationController.forward();
      opacityController.reverse();
      OverlayService().closeOverlay();

    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onVerticalDragUpdate: onVerticalDragUpdate,
        onVerticalDragEnd: onVerticalDragEnd,
        child: AnimatedBuilder(
          animation: animation,
          builder: (BuildContext context, Widget? child) {
            return  Transform.translate(
              offset: Offset(0, 20*animationController.value),
              child: FadeTransition(
                opacity: animationOpacity,
                child: buildUI(),
              )
            );
          },
        ),
      );
  }


  Widget buildUI () {
    return OverlayService().buildOverlayStyle(
      context,
      selfPositioned: false,
      child: Row(
        children: [
          const Spacer(flex: 2,),
          Expanded(
              flex: 8,
              child: buildPlayButton()
          ),
          const Spacer(flex: 3,),
          Expanded(
              flex: 50,
              child: buildMusicMeta(widget.song)
          ),
          const Spacer(flex: 3,),
          Expanded(
              flex: 8,
              child: buildLikeButton(widget.song.isLiked )
          ),
          const Spacer(flex: 2,),
        ],
        //   ),
        // ),
      ),
    );
  }

  Widget buildPlayButton () {
    return  InkWell(
      onTap: () async {
        final player = AudioProvider.player;

        if(!player.playing) {
          player.play();
        } else {
          player.pause();
        }

        setState(() { });
      },
      child: Container(
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: buildDropShadow
          ),

          child:  StreamBuilder<bool?>(
              stream: AudioProvider.player.playingStream,
              builder: (context , snapshot) {
                final isPlaying = snapshot.data ?? !AudioProvider.player.playing;
                return  BuildAssetIcon(iconName: isPlaying ?  'pauseButton' : 'playButtonBlack');
              })

      ),
    );
  }

  Widget buildMusicMeta (Song? song ) {

    TextStyle songStyle  = const  TextStyle(
        color: grey5,
        fontSize: 25,
        shadows: [
          Shadow(
              color: black3,
              offset: Offset(1, 0)
          ),
          Shadow(
              blurRadius: 2,
              color: black2,
              offset: Offset(2, 0)
          )
        ]
    );

    TextStyle singerStyle  = const  TextStyle(
        color: grey10,
        fontSize: 20,
        shadows: [
          Shadow(
              color: black3,
              offset: Offset(1, 0)
          ),
          Shadow(
              blurRadius: 2,
              color: black4,
              offset: Offset(2, 0)
          )
        ]
    );


    return StreamBuilder<Song>(
      stream: AudioProvider.activeSongStream,
      builder: (context, snapshot) {
        final song = snapshot.data ?? widget.song;

        if(snapshot.data != null) widget.song = song;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

              Expanded(
                // flex: 5,
                child: Text(
                    song.songName ,
                    style: songStyle
                ),
              ),
              Expanded(
                // flex: 7,
                child: FittedBox(
                  child: SizedBox(
                    width: size(context).width,
                    child: Text(
                        song is NetworkSong ? song.producer.producerName : (song as LocalSong).artist ,
                        // "producer",
                        style: singerStyle
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }

  Widget buildLikeButton (bool isLiked) =>  InkWell(
      onTap: () {
        isLiked = !isLiked;
        widget.song.isLiked = isLiked ;
        LibraryProvider.likedSongController.sink.add(widget.song);
        setState(() { });
      },
      child: BuildAssetIcon(iconName: isLiked ? "like" : "likeBlack" )
    );


}
