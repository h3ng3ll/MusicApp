// ignore_for_file: file_names

import 'package:equalizer_flutter/equalizer_flutter.dart';
import 'package:flutter/material.dart';
import 'package:music_app/src/presentation/UI/Screens/Home/ShareScreen/MusicAudioPlayerScreen/MusicPlayerTabBarWidget/EqualizerScreen/widget/CustomEQ.dart';
import 'package:music_app/src/presentation/core/constants.dart';
import 'package:music_app/src/presentation/service/ColorService.dart';

class BuildEQFrame extends StatelessWidget {
   const BuildEQFrame({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    final dSize  = size(context).width;

    return Padding(
      padding: const EdgeInsets.all(20),

      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(17.5)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(17.5)),
            border: Border.all(
              color: grey,
              width: 2
            )
          ),
          child: Stack(
            children: [

              FutureBuilder<List<int>>(
                future: EqualizerFlutter.getBandLevelRange(),
                builder: (context, snapshot) {
                  return snapshot.connectionState == ConnectionState.done
                      ? CustomEQ(bandLevelRange: snapshot.data!)
                      : const CircularProgressIndicator();
                },
              ),
              ...containerShadow(dSize)
            ],
          ),
        ),
      ),
    ) ;



  }

  List<Widget> containerShadow (double dSize) {

    const  thinSize = 2.0;

    return [
      /// top
      buildShadow(
          color: black2,
          width: dSize,
          height: thinSize,
          offset: const Offset(0 , 0)
      ),

      /// bottom

      Positioned(
        bottom: 0, left: 0, right: 0,
        child: buildShadow(
            color: white,
            width: dSize,
            height: thinSize,
            offset:  const Offset(0 , 10)
        ),
      ),

      /// left

      Positioned(
        bottom: 0, left: 0, top: 0,
        child: buildShadow(
            color: black2,
            width: thinSize,
            height: dSize,
            offset:  const Offset(-10 , 0)
        ),
      ),

      /// right

      Positioned(
        bottom: 0, right: 0, top: 0,
        child: buildShadow(
            color: white,
            width: thinSize,
            height: dSize,
            offset:  const Offset(10 , 0)
        ),
      ),
    ];
  }

  Widget buildShadow ({required Color color, required double width,required double height, required Offset offset,}) {
    return Container(
      width:  width,
      height: height,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
          boxShadow:  [
            BoxShadow(
                blurRadius: 20,
                spreadRadius: 0.5,
                color: color,
                offset: offset
            ),

          ]
      ),
    );
  }
}
