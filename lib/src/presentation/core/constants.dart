

import 'package:flutter/cupertino.dart';
import 'package:music_app/src/presentation/service/ColorService.dart';

Size size (BuildContext context) => MediaQuery.of(context).size;

double dynSize (BuildContext context) =>  (size(context).height - size(context).width) ;

List<BoxShadow> shadowGradientOfScreen () => [
  const BoxShadow(
      blurRadius: 1,
      color: grey4,
      offset: Offset(10 , -10)
    // offset: Offset.zero
  ),
  const BoxShadow(
      blurRadius: 4,
      color: black2,
      // offset: const Offset(0 , 4)
      offset: Offset(-15 , 20)

  ),


];

List<BoxShadow> buttonShadows ([Color? top , Color? bottom]) => [

   BoxShadow(
      // blurRadius: 1,
      color: top ?? grey12,
      spreadRadius: 2,
      // offset: const Offset(0 , 4)
      offset: const Offset(3 , -3)

  ),
  BoxShadow(
    blurRadius: 1,
      spreadRadius: 1,
      color: bottom ?? black2.withOpacity(0.7),
    offset: const Offset(-1, 4)
  ),

  ...buildDropShadow
];

List<BoxShadow> get buildDropShadow => [
  BoxShadow(
      blurRadius: 1,
      color:  black2.withOpacity(0.25),
      offset: const Offset(-3, 0)
  ),

  BoxShadow(
      blurRadius: 1,
      color: black2.withOpacity(0.25),
      offset: const Offset(0, -3)
  ),

  BoxShadow(
      blurRadius: 1,
      color:  black2.withOpacity(0.25),
      offset: const Offset(3, 0)
  ),


  BoxShadow(
      blurRadius: 1,
      color:  black2.withOpacity(0.25),
      offset: const Offset(0, 3)
  ),
];

Future<void> pushRoute (BuildContext context , {required Widget child}) {
  return Navigator.of(context).push(
      PageRouteBuilder(
          pageBuilder: (context , anim1 , anim2 ) => child,
          transitionsBuilder: (context , animation , animation2 , child) {

            const begin = Offset(1, 0);
            const end = Offset.zero;
            const curve = Curves.ease ;

            final tween = Tween(begin:  begin , end: end);
            final  curvedAnimation = CurvedAnimation(parent: animation, curve: curve);

            return SlideTransition(
                position: tween.animate(curvedAnimation),
                child: child
            );
          }
      )
  );
}


