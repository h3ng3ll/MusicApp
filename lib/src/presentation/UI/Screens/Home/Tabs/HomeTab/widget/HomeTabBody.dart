// ignore_for_file: file_names


import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:music_app/src/data/provider/LibraryProvider.dart';
import 'package:music_app/src/data/repository/SongsRepository.dart';
import 'package:music_app/src/domain/model/Library.dart';
import 'package:music_app/src/presentation/UI/Screens/Home/Tabs/HomeTab/widget/BuildTilesWithSongs.dart';
import 'package:music_app/src/presentation/core/constants.dart';


class HomeTabBody extends StatefulWidget {
  const HomeTabBody({Key? key}) : super(key: key);
  @override
  State<HomeTabBody> createState() => _HomeTabBodyState();
}

class _HomeTabBodyState extends State<HomeTabBody> {


   Library library = LibraryProvider.library;

  @override
  Widget build(BuildContext context) {

    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async {
          library = LibraryProvider.library;
          await Future.delayed(const Duration(seconds: 0));
          setState(() {});
        },
        child: ListView(
          children: [

            /// Recently Played

            FutureBuilder(
                future: SongsRepository.fetchSongFromHistory(),
                builder: ( context, snapshot) {
                  if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
                    final songs = snapshot.data!;
                    if(songs.isEmpty){
                      return Container();
                    }
                    return  BuildTilesWithSongs(
                        songs: songs,
                        title: AppLocalizations.of(context)!.recently_played
                    );
                  } else if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox(
                        height: size(context).height*0.2,
                        child: const Center(child: CircularProgressIndicator())
                    );
                  }
                  else if (snapshot.hasError) {
                    final e = snapshot.error;
                    return Text("Something went wrong $e");
                  }
                  else {
                    return Container();
                  }
                },
            ),



            /// Popular Music


            FutureBuilder(
              future: SongsRepository.fetchPopularSongs(),
              builder: ( context, snapshot) {
                if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
                  final songs = snapshot.data!;
                  return  BuildTilesWithSongs(
                      songs: songs,
                      title: AppLocalizations.of(context)!.popular_music
                  );
                } else if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox(
                      height: size(context).height*0.2,
                      child: const Center(child: CircularProgressIndicator())
                  );
                }
                else if (snapshot.hasError) {
                  final e = snapshot.error;
                  return Text("Something went wrong $e");
                }
                else {
                  return Container();
                }
              },
            ),

          ],
        ),
      ),
    );
  }
}
