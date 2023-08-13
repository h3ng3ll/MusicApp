// ignore_for_file: file_names


import 'package:flutter/material.dart';
import 'package:music_app/src/data/provider/LibraryProvider.dart';
import 'package:music_app/src/presentation/UI/Screens/Home/Tabs/LibraryTab/AlbumsScreen/widget/BuildAlbumGenredSong.dart';
import 'package:music_app/src/presentation/UI/Screens/Home/Tabs/LibraryTab/LibraryMusicItem.dart';
import 'package:music_app/src/presentation/core/constants.dart';
import 'package:music_app/src/presentation/core/widgets/BuildHeaderTitle.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class AlbumsScreen extends StatefulWidget {
  final double gap;
  const AlbumsScreen({Key? key, required this.gap}) : super(key: key);

  @override
  State<AlbumsScreen> createState() => _AlbumsScreenState();
}

class _AlbumsScreenState extends State<AlbumsScreen> {


  List<String> genres = [];

  @override
  void initState() {
    super.initState();
    for (var element in LibraryProvider.localLibrary.songs) {
          final genre = element.genre;
          if(genre != null && !genres.contains(genre)){
            genres.add(genre);
          }
    }
  }

  @override
  Widget build(BuildContext context) {

    final songs = LibraryProvider.localLibrary.songs;

    return Column(
      children: [
          BuildHeaderTitle(title: AppLocalizations.of(context)!.albums,),

          Expanded(
            child: Padding(
              padding:  EdgeInsets.all(widget.gap),
              child: GridView.builder(
                  padding:  const EdgeInsets.only(top: 3),
                  // physics: const NeverScrollableScrollPhysics(),
                  itemCount: genres.length,
                  itemBuilder: (context , index) => LibraryMusicItem(
                    localIconPath: 'assets/icons/music.png',
                    title: genres[index],
                    onTap: () {
                      final genre = genres[index] ;
                      final songsGenres = songs.where((element) => element.genre == genre).toList();
                      PersistentNavBarNavigator.pushNewScreen(context, screen: BuildAlbumGenredSong(songs: songsGenres, genre: genre,));
                    },
                  ),
                  gridDelegate:   SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: widget.gap -5,
                    crossAxisSpacing: widget.gap ,
                    crossAxisCount: 2,
                    mainAxisExtent: size(context).height/6,
                    childAspectRatio: 1.7,
                  ),
              ),
            ),
            // child: GroupedListView<Song , String>(
            //     elements: songs,
            //     /// by genre grouping
            //     groupBy: (song) => song.genre ?? "",
            //   // groupBy: (song) {
            //     //   final genre = song.genre;
            //     //   return genre != null && !genres.contains(genre);
            //     // },
            //     groupSeparatorBuilder: (String? song) {
            //       if(song != "" ){
            //         return SizedBox(
            //             height: 30,
            //             child: const Text("some"));
            //       } else {
            //         return const SizedBox();
            //       }
            //
            //     },
            //     itemBuilder: (context , Song element) {
            //       return SizedBox(
            //         width: size(context).width,
            //         height: size(context).height,
            //         child: GridView.builder(
            //             padding:  const EdgeInsets.only(top: 3),
            //             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //               mainAxisSpacing: widget.gap -5,
            //               crossAxisSpacing: widget.gap ,
            //               crossAxisCount: 2,
            //               // mainAxisExtent: 10,
            //               childAspectRatio: 1.7,
            //             ),
            //             itemBuilder: (context , index) => LibraryMusicItem(
            //                   localIconPath: 'assets/icons/music.png',
            //                   title: genres[index],
            //                   onTap: () {
            //
            //                   },
            //                 ),
            //         ),
            //       );
            //     },
            ),
              ],
          );

    // );
  }
}
