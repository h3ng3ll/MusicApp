// ignore_for_file: file_names
import 'dart:math' show pi;

import 'package:flutter/material.dart';
import 'package:music_app/src/presentation/core/widgets/BuildHeaderTitle.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MusicVideosScreen extends StatefulWidget {
  const MusicVideosScreen({Key? key}) : super(key: key);

  @override
  State<MusicVideosScreen> createState() => _MusicVideosScreenState();
}

class _MusicVideosScreenState extends State<MusicVideosScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 42);

    return Column(
      children: [
        BuildHeaderTitle(title: AppLocalizations.of(context)!.music_videos,),

        const Spacer(),
        Center(
          child: Transform.rotate(
              angle: pi / 5 ,
              child: Text(AppLocalizations.of(context)!.demo_version , style: theme)),
        ),
        const Spacer(),

      ],
    );
  }
}
