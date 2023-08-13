// ignore_for_file: file_names



import 'package:flutter/material.dart';
import 'package:music_app/src/presentation/service/ColorService.dart';


class TabViewWidget extends StatelessWidget {

  final List<Widget> items;

  const TabViewWidget({
    Key? key,
    required this.items,

  }) : super(key: key);

  

  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [

        Container(
          width: double.infinity,
          height: Theme.of(context).navigationBarTheme.height ,
          decoration: const BoxDecoration(
            color: brown,
            borderRadius: BorderRadius.vertical(top: Radius.circular(7.5))
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items,
          ),
        ),

        /// decoration line
        Align(
          alignment: const Alignment(0.0 , -1),
          child: ClipOval(
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    blurRadius: 20,
                    spreadRadius: 20,
                    color: white,
                  ),
                ]
              ),
              width: 150,
              height: 3,
            ),
          ),
        ),
      ],
    );
  }
}
