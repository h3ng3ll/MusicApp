// ignore_for_file: file_names


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/src/data/bloc/AudioPlayerBloc/audio_player_bloc.dart';
import 'package:music_app/src/data/provider/AudioProvider.dart';
import 'package:music_app/src/domain/repository/Song.dart';
import 'package:music_app/src/presentation/core/widgets/BuildAssetIcon.dart';

class TheLikeTabItem extends StatefulWidget {
  const TheLikeTabItem({Key? key}) : super(key: key);

  @override
  State<TheLikeTabItem> createState() => _TheLikeTabItemState();
}

class _TheLikeTabItemState extends State<TheLikeTabItem> {

   bool selected = false ;

   late final Song song;

   @override
  void initState() {
     super.initState();
     song = AudioProvider.activeSong;
     selected = song.isLiked;
  }


  @override
  Widget build(BuildContext context)  {
      return InkWell(
          onTap: () async {
            selected = !selected;
            BlocProvider.of<AudioPlayerBloc>(context , listen:  false).add(LikeSongEvent(song: song));
            setState(() {});
          },
          child:  BuildAssetIcon(iconName: selected ? "like" : "like2")
      );
  }
}
