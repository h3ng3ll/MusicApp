// ignore_for_file: file_names


import 'package:flutter/material.dart';
import 'package:music_app/src/presentation/UI/Screens/Home/Tabs/HomeTab/widget/HomeTabBody.dart';
import 'package:music_app/src/presentation/UI/Screens/Home/Tabs/HomeTab/widget/HomeHeaderWidget.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        SizedBox(height: size.height * 0.03,),
        const HomeHeaderWidget(),
        const HomeTabBody()
      ],
    );


  }
}
