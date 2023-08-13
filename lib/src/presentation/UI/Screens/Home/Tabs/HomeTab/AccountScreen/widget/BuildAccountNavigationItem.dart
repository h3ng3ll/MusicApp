


// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:music_app/src/presentation/core/widgets/BuildAssetIcon.dart';
import 'package:music_app/src/presentation/service/ColorService.dart';

class BuildAccountNavigationItem extends StatelessWidget {

  final String iconName;
  final String title;
  final Function ()? onTap ;

  const BuildAccountNavigationItem({Key? key, required this.iconName, required this.title, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {


  const  double blur = 3 ;
  const style = BlurStyle.normal;

    return InkWell(
      onTap: onTap,
      child: Container(

        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: grey5,

          borderRadius: BorderRadius.circular(5),
          // shape: BoxShape.circle,
          boxShadow: const [
            /// black

            BoxShadow(
              blurStyle: style,
                blurRadius: blur,
                color: black,
                offset: Offset(-7 , -7)
            ),

            BoxShadow(
                blurStyle: style,
                blurRadius: blur,
                color: black,
                offset: Offset(-7 , 7)
            ),
            BoxShadow(
                blurStyle: style,
                blurRadius: blur,
                color: black,
                offset: Offset(7 , 7)
            ),
            //
            //
            BoxShadow(
                blurStyle: style,
              blurRadius: blur,
              color: grey3,
              offset: Offset(2 , -10)
            ),
            BoxShadow(
                blurStyle:  style,
                blurRadius: blur,
                color: grey3,
                offset: Offset(10 , -10)
            ),

            BoxShadow(
                blurStyle: style,
                blurRadius: blur,
                color: grey3,
                offset: Offset(10 , -2)
            ),
          ]
        ),
        child: buildContent(context),
      ),
    );
  }

  Widget buildContent(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    final labelSmall = theme.labelSmall?.copyWith(fontSize: 22);

    return  Row(
      children: [
        BuildAssetIcon(iconName: iconName),
        const Spacer(flex: 9,),
        Text(title , style: labelSmall,),
        const Spacer(flex: 10,),
      ],
    );
  }
}
