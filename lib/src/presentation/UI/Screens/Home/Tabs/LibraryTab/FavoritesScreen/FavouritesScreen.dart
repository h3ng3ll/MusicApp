// ignore_for_file: file_names


import 'package:flutter/material.dart';
import 'package:music_app/src/presentation/UI/Screens/Home/Tabs/LibraryTab/FavoritesScreen/widget/BuildExternalFavorites.dart';
import 'package:music_app/src/presentation/UI/Screens/Home/Tabs/LibraryTab/FavoritesScreen/widget/BuildLocalFavorites.dart';
import 'package:music_app/src/presentation/core/constants.dart';
import 'package:music_app/src/presentation/core/widgets/BuildHeaderTitle.dart';
import 'package:music_app/src/presentation/core/widgets/TextFormFieldContainer.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FavouritesScreen extends StatefulWidget {
  final double gap ;
  const FavouritesScreen({Key? key, required this.gap}) : super(key: key);

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {



  List<Widget> buildFavorite  = [
    BuildExternalFavorites(),
    const BuildLocalFavorites(),
  ];

  List<String> titles (BuildContext context)=>  [
    AppLocalizations.of(context)!.external,
    AppLocalizations.of(context)!.local,
  ];

  @override
  Widget build(BuildContext context) {

    final labelSmall = Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 24);
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: widget.gap),
      child: Column(
        children: [
          BuildHeaderTitle(title: AppLocalizations.of(context)!.favourites),

          SizedBox(height: widget.gap,),

          Expanded(
            child: ListView.builder(
                itemCount: buildFavorite.length,
                itemBuilder: (context , index) => Padding(
                  padding:  EdgeInsets.only(top: widget.gap),
                  child: InkWell(
                    onTap: () {
                      PersistentNavBarNavigator.pushNewScreen(
                          context, screen: Scaffold(body: buildFavorite[index]));
                    },
                    child: TextFormFieldContainer(
                      child: SizedBox(
                          width: size(context).width,
                          child: Center(child: Text(titles(context)[index] ,style:  labelSmall,))
                      ),
                    ),
                  ),
                )
            ),
          ),


        ],
      ),
    );
  }

}
