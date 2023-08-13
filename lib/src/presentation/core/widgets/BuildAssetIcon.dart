// ignore_for_file: file_names



import 'package:flutter/material.dart';

class BuildAssetIcon extends StatelessWidget {

  const BuildAssetIcon({
    Key? key,
    required this.iconName,
    this.size,
    this.color
  }) : super(key: key);

  final String iconName;
  final double? size ;
  final Color? color ;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final  wSize  = size ?? width/15;


    return Image.asset(
      "assets/icons/$iconName.png",
      color: color,
      width:  wSize ,
      height: wSize,
    );
  }
}
