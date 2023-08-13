// ignore_for_file: file_names



import 'package:flutter/material.dart';
import 'package:music_app/src/presentation/core/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ClearSearchHistory extends StatelessWidget {
  

  final Future Function () onTap;
  const ClearSearchHistory({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final labelSmall = Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 22);

    return Column(
      children: [
        SizedBox(height: size(context).height*0.02,),
        InkWell(
          onTap: () async {
            await onTap();
          },
          child: Align(
              alignment: const  Alignment(-0.8  , 1),
              child: Text(AppLocalizations.of(context)!.clear_search_history , style:  labelSmall,)
          ),
        ),
        SizedBox(height: size(context).height*0.02,),
      ],
    );
  }
}
