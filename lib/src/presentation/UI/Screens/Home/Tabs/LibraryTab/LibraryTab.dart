// ignore_for_file: file_names


import 'package:flutter/material.dart';
import 'package:music_app/src/presentation/UI/Screens/Home/Tabs/LibraryTab/BuildLIbraryGridWidget.dart';
import 'package:music_app/src/presentation/UI/Screens/Home/Tabs/LibraryTab/BuildLibraryRecentlyAddedWidget.dart';
import 'package:music_app/src/presentation/core/widgets/BuildHeaderTitle.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:music_app/src/presentation/core/constants.dart';

class LibraryTab extends StatelessWidget {
  const LibraryTab({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {


    final  bodyTheme = Theme.of(context).textTheme.titleSmall;

     double gap = dynSize(context)/15;

    return Column(
      children: [

          /// Library

          BuildHeaderTitle(title: AppLocalizations.of(context)!.library),
          // SizedBox(height: size.height*0.01,),


          Expanded(
            child: Padding(
              padding:  EdgeInsets.all(gap),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      flex: 30,
                      child: BuildLibraryGridWidget(gap: gap,)
                  ),
                  const Spacer(flex: 4,),


                  Text( AppLocalizations.of(context)!.recently_added , style: bodyTheme,),
                  const Spacer(),

                  Expanded(
                      flex: 4,
                      child: BuildLibraryRecentlyAddedWidget(gap: gap )
                  ),
                  // Spacer(),
                  // SizedBox(height: size.height*0.02,),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
