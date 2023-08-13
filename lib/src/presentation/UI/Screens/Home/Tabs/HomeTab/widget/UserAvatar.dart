// ignore_for_file: file_names


import 'package:flutter/material.dart';
import 'package:music_app/src/presentation/service/ColorService.dart';

class UserAvatar extends StatelessWidget {

  final String? imgUrl ;
  const UserAvatar({Key? key, required this.imgUrl}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    const double diameter = 45.0;

    return Container(
      width: diameter,
      height: diameter,

      decoration:    BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: const [

            /// surrounds corners
            BoxShadow(
              blurRadius: 1,
              spreadRadius: 4,
              color: black,
              offset: Offset(5, 0),

            ),


            /// black gradient
            BoxShadow(
              blurRadius: 0,
              spreadRadius: 3,
              color: black,
              offset: Offset(-4, -1),
            ),
            /// grey gradient
            BoxShadow(
              blurRadius: 1,
              spreadRadius: 1,
              color: grey,
              offset: Offset(3, -2),
            ),

          ],
          gradient: const RadialGradient(
              colors: [
                grey , black
              ]
          ),
          image:    DecorationImage(
            image: imgUrl != null ?
                  NetworkImage(imgUrl!) :
                  const AssetImage("assets/icons/defaultSongImage.png") as ImageProvider,
            fit: BoxFit.cover,
          )
      ),
    );
  }
}
