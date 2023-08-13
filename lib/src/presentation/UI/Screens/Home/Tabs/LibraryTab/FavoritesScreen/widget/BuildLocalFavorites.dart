// ignore_for_file: file_names



import 'package:flutter/material.dart';
import 'package:music_app/src/data/provider/LibraryProvider.dart';
import 'package:music_app/src/presentation/core/widgets/BuildSongTileItem.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BuildLocalFavorites extends StatelessWidget {
  const BuildLocalFavorites({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

      final favoriteSongs = LibraryProvider.localLibrary.favorites;

      if(favoriteSongs.isNotEmpty){
        return Column(
            children: [
              Expanded(
                child: ListView.builder(
                    itemCount: favoriteSongs.length,
                    itemBuilder: (context , index) {
                      return BuildSongTileItem(
                        song: favoriteSongs[index],
                        songs: favoriteSongs,
                      );
                    }
                ),
              ),
            ]
        );
      } else {
        final theme = Theme.of(context).textTheme.labelSmall;
        return Center(
            child: Text(AppLocalizations.of(context)!.add_your_first_song, style: theme)
        );
     }
  }
}
