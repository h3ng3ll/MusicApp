// ignore_for_file: file_names




import 'package:flutter/material.dart';
import 'package:music_app/src/presentation/service/ColorService.dart';

class LibraryMusicItem extends StatelessWidget {


  const LibraryMusicItem({
    Key? key,
    required this.localIconPath,
    required this.title,
    required this.onTap
  }) : super(key: key);

  final String localIconPath ;
  final String title ;
  final void Function () onTap ;

  Widget buildIcon () {
    return Align(
      alignment: const Alignment(0 , -0.7),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(7.5),
        child: Container(
          height: 40,
          width: 60,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7.5),
              boxShadow: [
               const  BoxShadow(
                    color: grey5,
                ),
                BoxShadow(
                    color: white.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: -3,
                    offset: const Offset(5 , 5)
                ),
                BoxShadow(
                    color: black2.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(-5 , -5)
                )
              ],
          ),
          child: Image.asset(localIconPath),
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {

    const size = 20.0 ;
    final  titleSmall = Theme.of(context).textTheme.titleSmall;

    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: brown,
          borderRadius: BorderRadius.circular(12.5),
          boxShadow: [
            const BoxShadow(
                color: grey4,
                blurRadius: 1,
                offset: Offset(0 , -3)
            ),
            BoxShadow(
                color: black.withOpacity(0.25),
                blurRadius: 4,
                offset: const Offset(0 , 4)
            ),
          ]
        ),
        height: size,
        width: size,
        child: Stack(
          children: [
            buildIcon(),

            Align(
                alignment: const Alignment(0 , 0.55),
                child: Text(title , style: titleSmall, textAlign: TextAlign.center,)
            )

          ],
        ),
      ),
    );
  }
}
