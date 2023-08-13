// ignore_for_file: file_names


import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:music_app/src/presentation/UI/Screens/Home/Tabs/LibraryTab/LibraryMusicItem.dart';
import 'package:music_app/src/presentation/UI/Screens/Home/Tabs/LibraryTab/AlbumsScreen/AlbumsScreen.dart';
import 'package:music_app/src/presentation/UI/Screens/Home/Tabs/LibraryTab/DownloadsScreen.dart';
import 'package:music_app/src/presentation/UI/Screens/Home/Tabs/LibraryTab/FavoritesScreen/FavouritesScreen.dart';
import 'package:music_app/src/presentation/UI/Screens/Home/Tabs/LibraryTab/MusicVideosScreen.dart';
import 'package:music_app/src/presentation/UI/Screens/Home/Tabs/LibraryTab/PlaylistsScreen/PlaylistsScreen.dart';
import 'package:music_app/src/presentation/UI/Screens/Home/Tabs/LibraryTab/SongsScreen.dart';
import 'package:music_app/src/data/provider/AudioProvider.dart';
import 'package:music_app/src/data/provider/LibraryProvider.dart';
import 'package:music_app/src/presentation/core/constants.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';

class BuildLibraryGridWidget extends StatelessWidget {
   BuildLibraryGridWidget({Key? key, required this.gap}) : super(key: key);

   final double gap ;

  final List<String> icons = [
    "playlists",
    "albums",
    "like",
    "download",
    "music_videos",
    "notes"
  ] ;

  List<String> titles (BuildContext context) => [
    AppLocalizations.of(context)!.playlists,
    AppLocalizations.of(context)!.albums,
    AppLocalizations.of(context)!.favourites,
    AppLocalizations.of(context)!.downloads,
    AppLocalizations.of(context)!.music_videos,
    AppLocalizations.of(context)!.songs,
  ];

  List<Widget> libraryScreens  ()  =>  [
    const PlaylistsScreen(),
    AlbumsScreen(gap: gap),
    FavouritesScreen(gap: gap),
    const DownloadsScreen(),
    const MusicVideosScreen(),
    const SongsScreen()
  ];

  @override
  Widget build(BuildContext context) {

    final libraryProvider = Provider.of<LibraryProvider>(context , listen:  false);
    MediaQuery.of(context).size.height%2;

    return GridView.builder(
        padding:  const EdgeInsets.only(top: 3),
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate:   SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisSpacing: gap -5,
            crossAxisSpacing: gap ,
            crossAxisCount: 2,
            mainAxisExtent: size(context).height/6,
          childAspectRatio: 1.7,
        ),
        itemCount: icons.length,
        itemBuilder: (context , index ) => LibraryMusicItem(
            localIconPath: "assets/icons/${icons[index]}.png",
            title: titles(context)[index],
            onTap: () => onTap( context ,  libraryProvider , index)
        )
    );
  }


  void onTap (BuildContext context , LibraryProvider libraryProvider , int index ) {
    final audioProvider = Provider.of<AudioProvider>(context , listen:  false);

    PersistentNavBarNavigator.pushNewScreen(
        context,
        screen: MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: audioProvider),
            ChangeNotifierProvider.value(value: libraryProvider),
          ],
          child: Scaffold(
              body: SafeArea(
                  child: libraryScreens()[index]
              )
          ),
        )
    );
  }
}
