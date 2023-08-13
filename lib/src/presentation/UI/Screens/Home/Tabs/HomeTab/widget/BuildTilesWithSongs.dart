// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:music_app/src/data/provider/AudioProvider.dart';
import 'package:music_app/src/data/provider/LibraryProvider.dart';
import 'package:music_app/src/presentation/UI/Screens/Home/ShareScreen/MusicAudioPlayerScreen/MusicAudioPlayerScreen.dart';
import 'package:music_app/src/presentation/core/widgets/BuildAvatarImage.dart';
import 'package:music_app/src/presentation/core/constants.dart';
import 'package:music_app/src/domain/model/song/NetworkSong.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';

class BuildTilesWithSongs extends StatelessWidget {
  const BuildTilesWithSongs({
    Key? key,
    required this.songs,
    required  this.title
  }) : super(key: key);

  final List<NetworkSong> songs;
  final String title;

  
  void onCellTap (BuildContext context , int index) {
    final libraryProvider = Provider.of<LibraryProvider>(context , listen:  false);
    final provider = Provider.of<AudioProvider>(context , listen:  false) ;

    PersistentNavBarNavigator.pushNewScreen(
      context,
      withNavBar: false,
      screen: MultiProvider(
        providers: [
          ChangeNotifierProvider<LibraryProvider>.value(value: libraryProvider),
          ChangeNotifierProvider.value(value: provider,)
        ],
        child: MusicAudioPlayerScreen(
            song: songs[index],
            songs: songs
        ),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final  imageHeight = size(context).height*0.15  ;
    final  EdgeInsets padding  = EdgeInsets.symmetric(horizontal: size(context).width*0.015);


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildTitle(padding , context),
        SizedBox(height: size(context).height*0.015,),
        buildCells(imageHeight , padding , context , ),


      ],
    );
  }

  Widget buildTitle (EdgeInsets padding , BuildContext context) {
    final titleMedium = Theme.of(context).textTheme.titleMedium;

    return    Padding(
      padding: padding,
      child: Text(title, style: titleMedium),
    );
  }

  Widget buildCells (double imageHeight , EdgeInsets padding , BuildContext context ){


    return SizedBox(
      height: imageHeight + 20,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: songs.length,

        itemBuilder: (context , index) =>   InkWell(
          borderRadius: BorderRadius.circular(30),
          customBorder:  RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          onTap: () => onCellTap(context , index),
          child: BuildAvatarImage(
              circularRadius: 7,
              imgUrl:  songs[index].coverUri?.toString() ?? songs[index].album?.coverPath,
              height: imageHeight  ,
              width: imageHeight  ,
              padding: padding
          ),
        ),
      ),
    );
  }
}
