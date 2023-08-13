// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/src/data/bloc/AudioPlayerBloc/audio_player_bloc.dart';
import 'package:music_app/src/data/provider/AudioProvider.dart';
import 'package:music_app/src/domain/repository/Song.dart';
import 'package:music_app/src/presentation/core/constants.dart';
import 'package:music_app/src/presentation/service/ColorService.dart';
import 'package:provider/provider.dart';

class MusicActionsPanel extends StatefulWidget {


  final Song song;

  const MusicActionsPanel({Key? key, required this.song}) : super(key: key);

  @override
  State<MusicActionsPanel> createState() => _MusicActionsPanelState();
}

class _MusicActionsPanelState extends State<MusicActionsPanel> {



  @override
  Widget build(BuildContext context) {


    final audioProvider = Provider.of<AudioProvider>(context);
    final height = size(context).height;

    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: size(context).width * 0.07
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Container(
            padding: const EdgeInsets.all(5),
            decoration: AudioProvider.player.shuffleModeEnabled ?  BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: gold , width: 1)
            ) : null,
            child: buildIcon(
                getPath("shuffle"),
                onTap: () async {
                 await audioProvider.switchShuffleMode();
                 setState(() {  });
                },
                cSize: height*0.04,
            ),
          ),

          AudioProvider.player.hasPrevious ?   buildIcon(
              getPath("previous"),
              onTap: () =>
                BlocProvider.of<AudioPlayerBloc>(context , listen:  false)
                    .add(PlayPreviousSongEvent()),
                // audioProvider.previous();
              cSize: height*0.05,

          ) : SizedBox(width: height*0.05,),


          playPauseButton( audioProvider),

          AudioProvider.player.hasNext ?  buildIcon(
              getPath("next"),
              onTap: () {
                BlocProvider.of<AudioPlayerBloc>(context , listen:  false)
                    .add(PlayNextSongEvent());},
              cSize: height*0.05,

          ) : SizedBox(width: height*0.05,),

          Container(
            padding: const EdgeInsets.all(5),
              decoration: audioProvider.loopMode ?  BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: gold , width: 1)
              ) : null,
            child: buildIcon(
                getPath("repeating"),
                onTap: () {
                  audioProvider.toggleLoopMode();
                  setState(() { });
                },
                cSize: height*0.04,

            ),
          ),
        ],
      ),
    );
  }

  String getPath(iconName) => "assets/icons/$iconName.png";

  Widget buildIcon(String iconPath, {required Function() onTap ,required double cSize  }) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Image.asset(
        iconPath,
        width: cSize ,
        height: cSize ,
      ),
    );
  }

  Widget playPauseButton(AudioProvider audioProvider) {
    final dynSize = size(context).height*0.06;

    if (audioProvider.isPlaying ) {
      return buildIcon(
          getPath( "pauseButton" ),
          cSize: dynSize,
          onTap: () => audioProvider.pause()
      );
    } else {
      return buildIcon(
          getPath("playButton"),
          cSize: dynSize,
          onTap: () => audioProvider.play(widget.song)
      );
    }

  }
}
