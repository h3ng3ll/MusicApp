// ignore_for_file: file_names


import 'package:flutter/material.dart';
import 'package:music_app/src/presentation/service/ColorService.dart';

class TextFormFieldContainer extends StatelessWidget {
  const TextFormFieldContainer({Key? key, required this.child, this.padding}) : super(key: key);

  final Widget child;
  final double? padding;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(17),

      child: Container(
          padding: EdgeInsets.all( padding ?? 10.0),

          decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(17),
          boxShadow: [
            const  BoxShadow(
              color: black,
            ),
            BoxShadow(
                color: white.withOpacity(0.2),
                blurRadius: 20,
                // spreadRadius: ,
                offset: const Offset(5 , 5)
            ),
            BoxShadow(
                color: black2.withOpacity(0.3),
                blurRadius: 2,
                offset: const Offset(-7 , -7)
            ),


          ],
        ),
        child: child
      ),
    );
  }
}
