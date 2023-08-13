// ignore_for_file: file_names



import 'package:flutter/material.dart';
import 'package:music_app/src/presentation/service/ColorService.dart';

class BuildHeaderTitle extends StatelessWidget {

  const BuildHeaderTitle({Key? key, required this.title,  this.beforeTitle = const [],  this.afterTitle = const []}) : super(key: key);

  final String title;

  final List<Widget> beforeTitle;
  final List<Widget> afterTitle;

  @override
  Widget build(BuildContext context) {

    final headerStyle = Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 35);
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        if(beforeTitle.isEmpty && afterTitle.isEmpty) SizedBox(height: size.height*0.02,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ...beforeTitle,
            Text(title, style: headerStyle),
            ...afterTitle
            // buildImages(iconHeight),
          ],
        ),
        SizedBox(height: size.height*0.01,),
        Container(
          height: 1,
          width: double.infinity,
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, 1),
                  color: black2
              )
            ],
            color: grey3,
          ),
        )

      ],
    );
  }
}
