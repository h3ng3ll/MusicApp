// ignore_for_file: file_names


import 'package:flutter/material.dart';
import 'package:music_app/src/presentation/core/constants.dart';
import 'package:music_app/src/presentation/service/ColorService.dart';

class BuildScreenOffsetShadows extends StatelessWidget {

  final Widget child;
  const BuildScreenOffsetShadows({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: shadowGradientOfScreen(),
        ),
        child: Material(
          color: transparent,
          child: child,
        )
    );
  }
}
