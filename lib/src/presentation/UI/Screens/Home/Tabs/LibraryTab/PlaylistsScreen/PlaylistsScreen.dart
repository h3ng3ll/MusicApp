// ignore_for_file: file_names

import 'dart:math' show pi;

import 'package:flutter/material.dart';
import 'package:music_app/src/presentation/core/widgets/BuildHeaderTitle.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PlaylistsScreen extends StatefulWidget {
  const PlaylistsScreen({Key? key}) : super(key: key);

  @override
  State<PlaylistsScreen> createState() => _PlaylistsScreenState();
}

class _PlaylistsScreenState extends State<PlaylistsScreen> {



  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 42);

    return Column(
      children: [
        BuildHeaderTitle(title: AppLocalizations.of(context)!.playlists,),

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
