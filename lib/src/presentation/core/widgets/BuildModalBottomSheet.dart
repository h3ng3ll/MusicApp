// ignore_for_file: file_names



import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:music_app/src/presentation/service/ColorService.dart';

class BuildModalBottomSheet extends StatelessWidget {
  const BuildModalBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: grey4,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context , ImageSource.camera);
            },
            child: ListTile(
              title: Text(AppLocalizations.of(context)!.camera),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pop(context , ImageSource.gallery);
            },
            child: ListTile(
              title: Text(AppLocalizations.of(context)!.gallery),
            ),
          ),
        ],
      ),
    );
  }
}
