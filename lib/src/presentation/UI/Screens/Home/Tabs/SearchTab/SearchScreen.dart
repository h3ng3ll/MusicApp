// ignore_for_file: file_names



import 'package:flutter/material.dart';
import 'package:music_app/src/presentation/UI/Screens/Home/Tabs/SearchTab/MusicSearchDelegate.dart';
import 'package:music_app/src/presentation/core/widgets/BuildAssetIcon.dart';
import 'package:music_app/src/presentation/core/widgets/TextFormFieldContainer.dart';
import 'package:music_app/src/presentation/core/constants.dart';
import 'package:music_app/src/presentation/service/ColorService.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final labelSmall = Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 22);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          SizedBox(height: size(context).height*0.06),
          buildSearchBar(labelSmall , context),

          SizedBox(height: size(context).height*0.02),

          const Spacer(),
          buildMagnifierIcon(context),
          const Spacer(),
        ],
      ),
    );
  }

  Widget buildSearchBar (TextStyle? labelSmall , BuildContext context) {
    return  InkWell(
      onTap: () async {
        await showSearch(context: context, delegate: MusicSearch());
      },
      child: TextFormFieldContainer(

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("${AppLocalizations.of(context)!.search}..." , style: labelSmall?.copyWith(color: white)),
            const BuildAssetIcon(iconName: "searchWhite")
          ],
        ),
      ),
    );
  }

  Widget buildMagnifierIcon(BuildContext context) => Center(
    child: BuildAssetIcon(
      iconName: "searchBig",
      size: dynSize(context)/2,
      color: grey11,
    ),
  );
}


