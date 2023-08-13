// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/src/data/bloc/AudioPlayerBloc/audio_player_bloc.dart';
import 'package:music_app/src/data/provider/UserProvider.dart';
import 'package:music_app/src/domain/model/song/NetworkSong.dart';
import 'package:music_app/src/presentation/core/widgets/BuildAssetIcon.dart';

class BuildAddUserIcon extends StatefulWidget {

  final NetworkSong song ;
  final double dynSize;
  const BuildAddUserIcon({Key? key, required this.dynSize, required this.song}) : super(key: key);

  @override
  State<BuildAddUserIcon> createState() => _BuildAddUserIconState();
}

class _BuildAddUserIconState extends State<BuildAddUserIcon> {

  bool selected = false ;

  @override
  void initState() {


    /// check library if
    /// it has  added producer before .

    selected =  UserProvider.user.following.contains(widget.song.producer.id);

    super.initState();
  }

  void onTap () async {

    final uids = UserProvider.user.following;

    if(selected == false){
      final newProducers = {...uids , widget.song.producer.id}.toList();
      BlocProvider.of<AudioPlayerBloc>(context , listen: false).add(FollowUserEvent(uids: newProducers));
      selected = true;
    } else {
      final index = uids.indexOf(widget.song.producer.id);
      if(index == -1 ) return ;
      uids.removeAt(index);
      BlocProvider.of<AudioPlayerBloc>(context , listen: false).add(FollowUserEvent(uids: uids));
      selected = false;
    }

    setState(() {});

  }

  @override
  Widget build(BuildContext context) {


    return InkWell(
        onTap: onTap,
        child:  BuildAssetIcon(
            size: widget.dynSize,
            iconName: selected ? "userAdd2" : "userAdd"
        )
    );
  }
}
