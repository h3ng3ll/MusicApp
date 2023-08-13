// ignore_for_file: file_names


import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:music_app/src/presentation/service/ColorService.dart';

class BuildAvatarImage extends StatelessWidget {


  const BuildAvatarImage({
    Key? key,
    this.imgUrl,
    this.width = 150.0,
    this.height = 150.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 12.5),
    this.circularRadius,
    this.boxFit = BoxFit.cover,
    this.file,
    this.shape =  BoxShape.rectangle ,
    this.circleRadius,
    this.boxShadow,
    this.goldShadow = false,
    this.cache ,

  }) :  super(key: key) ;

  factory BuildAvatarImage.empty({
    List<BoxShadow>? boxShadow,
    double width = 150.0,
    double height = 150.0,
    EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 12.5),
    double?  circularRadius,
    File? file,
    BoxFit boxFit = BoxFit.cover,
    bool goldShadow = false,
  }) => BuildAvatarImage(
      width: width,
      height: height,
      padding: padding,
      circularRadius: circularRadius,
      boxFit: boxFit,
      file: file,
      boxShadow: boxShadow,
      goldShadow: goldShadow,
  );

  /// can store local and internet
  /// path . But in order to
  /// use localPath need change
  /// [local] field to [$true]
  final String? imgUrl ;
  final double width;
  final double height;
  final EdgeInsets padding ;
  final double? circularRadius;
  final BoxFit boxFit;
  final File? file ;
  final BoxShape shape ;
  final double? circleRadius;
  final List<BoxShadow>? boxShadow;
  final bool goldShadow ;

  final Uint8List? cache ;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if ( goldShadow && file == null && imgUrl == null) Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                  boxShadow: [
                     BoxShadow(
                        color: gold,
                        spreadRadius: 0.1,
                        blurRadius: 200
                    )
                  ],
                  shape: BoxShape.circle
              ),
              width: width,
              height: height,

            )
        ),

        Padding(
          padding: padding,
          child: Center(
            child: Container(
              width: width,
              height: height,
              // padding: EdgeInsets.all(10),
              decoration:  BoxDecoration(
                shape: shape,
                image: DecorationImage(
                    fit: boxFit,

                    image: file != null ? FileImage(file!) :
                           imgUrl != null ?
                           NetworkImage(imgUrl!) :
                           cache != null ?
                           MemoryImage(cache!) :
                           const AssetImage("assets/icons/defaultSongImage.png") as ImageProvider
                ),

                borderRadius:  shape != BoxShape.circle ? BorderRadius.all(Radius.circular(circularRadius ?? 30)) : null ,
                boxShadow: boxShadow ?? [
                  const BoxShadow(
                    blurRadius: 1,
                    color: grey4,
                    offset: Offset(0 , -5)
                  ),
                  BoxShadow(
                      blurRadius: 4,
                      color: black2.withOpacity(0.25),
                      offset: const Offset(0 , 4)
                  ),
                ]
              ),

            ),
          ),
        ),
      ],
    );
  }

}

