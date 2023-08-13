// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:music_app/src/presentation/core/constants.dart';
import 'package:music_app/src/presentation/core/paint/SliderGradientShape.dart';
import 'package:music_app/src/presentation/service/ColorService.dart';

/// The Application uses only Dark theme nowadays.
ThemeData defaultTheme (BuildContext context) => ThemeData(

    textSelectionTheme: TextSelectionThemeData(
        cursorColor: gold,
        selectionHandleColor: gold2,
        selectionColor: white.withOpacity(0.3)
    ),
    inputDecorationTheme: const InputDecorationTheme(
      hoverColor: gold2,
      alignLabelWithHint: false,
      focusColor: gold,
      contentPadding: EdgeInsets.zero,
      border: InputBorder.none,
      // hintStyle: TextStyle(
      //     color: white,
      //     fontWeight: FontWeight.bold,
      //     fontSize: 15,
      //     shadows:  [
      //       Shadow(
      //           color: black2.withOpacity(0.5),
      //           offset: const Offset(-4, 4),
      //           blurRadius: 2
      //       ),
      //       Shadow(
      //           color: white,
      //           offset: const Offset(0.1, 0)
      //       ),
      //       Shadow(
      //           color: white,
      //           offset: const Offset(1, 1),
      //           blurRadius: 1
      //       ),
      //       const Shadow(
      //           color: grey9,
      //           offset: Offset(0.5, -0.5),
      //           blurRadius: 1
      //       ),
      //     ]
      // ),

    ),

    appBarTheme: AppBarTheme(
      color: grey5,
      // shape: CircleBorder(
      //     side: BorderSide(color: white , width: 3) ),
      titleTextStyle: TextStyle(
        color: white,
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
        height: size(context).height/15
    ),
    fontFamily: "Inter",
    scaffoldBackgroundColor: grey5,
    sliderTheme: SliderThemeData(
        activeTrackColor: gold,
        thumbColor: gold,
        trackShape: SliderGradientShape(),
        thumbShape: const RoundSliderThumbShape()
    ),
    textTheme:  TextTheme(
        /// Above title of the screen style
        titleLarge: const TextStyle(
            fontSize: 42 ,
            color: grey2,
            fontWeight: FontWeight.w500,
            shadows: [
              Shadow(
                  color: grey,
                  offset: Offset(2, 0)
              ),
              Shadow(
                  color: black2,
                  offset: Offset(4, 0)
              ),

            ]
        ),
        /// Gold
        titleMedium: TextStyle(
            fontSize: 25 ,
            // color: gold,
            foreground: Paint()..shader = const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                gold,
                gold2,
                gold
              ],
              // stops: [
              //   0.0 , 0.3 ,  0.4
              // ]
            ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
            fontWeight: FontWeight.w900,
            shadows: const [
              Shadow(
                  color: grey,
                  offset: Offset(2, 0)
              ),
              Shadow(
                  color: black2,
                  offset: Offset(4, 0)
              ),

            ]
        ),
        /// wifi things
        labelSmall: TextStyle(
            letterSpacing: 0.4,
            color: white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
            shadows:  [
              Shadow(
                  color: black2.withOpacity(0.5),
                  offset: const Offset(-4, 4),
                  blurRadius: 2
              ),
              Shadow(
                  color: white,
                  offset: const Offset(0.1, 0)
              ),
              const Shadow(
                  color: grey9,
                  offset: Offset(1, 1),
                  blurRadius: 1
              ),
              const Shadow(
                  color: grey9,
                  offset: Offset(0.5, -0.5),
                  blurRadius: 1
              ),
            ]
        ),
        titleSmall: TextStyle(
            fontSize: 20 ,
            // color: gold,

            foreground: Paint()..shader = const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.topRight,
                colors: [
                  gold2,
                  gold
                ]
            ).createShader(
              // Rect.fromLTRB(1, 0, 0, 0),
              // Rect.fromLTWH(40, 20, 5, 100)
              const Rect.fromLTWH(70, 70, 50, 50),
              // textDirection: TextDirection.rtl
            ),
            fontWeight: FontWeight.w600,
            shadows: const [
              Shadow(
                  color: grey,
                  offset: Offset(2, 0)
              ),
              Shadow(
                  color: black2,
                  offset: Offset(4, 0)
              ),

            ]
        ),
        labelMedium: const TextStyle(
            fontSize: 25 ,
            color: grey7,
            fontWeight: FontWeight.w900,
            shadows: [
              Shadow(
                  blurRadius: 1,
                  color: black2,
                  offset: Offset(1.5, 0)
              ),
            ]
        ),
        bodyMedium: const  TextStyle(
          fontSize: 24 ,
          color: black2,
          fontWeight: FontWeight.w900,
          // shadows: [
          //   Shadow(
          //       blurRadius: 6,
          //       color: black2,
          //       offset: Offset(0.5 , 0.5)
          //   ),
          // ]
        ),
        displayMedium: TextStyle(
            color: gold,
            fontWeight: FontWeight.w500,
            shadows: [
              Shadow(
                  offset: const Offset(-4, 4),
                  blurRadius: 2,
                  color: black2.withOpacity(0.5)
              ),
              Shadow(
                  offset:const  Offset(0.1, 0),
                  color: white
              ),
              Shadow(
                  offset: const Offset(-1, -1),
                  blurRadius: 1,
                  color: white
              ),
              const Shadow(
                  offset:  Offset(1, 1),
                  blurRadius: 1,
                  color: grey9
              ),
            ]
        ),
        /// Macondo font
        headlineLarge: TextStyle(
            fontFamily: "Macondo",
            fontSize: 50,
            fontWeight: FontWeight.w200,
            color:  gold8,
            shadows: [
              Shadow(
                  offset: const Offset(1, 0),
                  blurRadius: 1,
                  color: black2.withOpacity(0.5)
              ),
              const Shadow(
                  offset: Offset(1, 0),
                  color: white2
              ),
              const Shadow(
                  offset: Offset(0, 3),
                  blurRadius: 3,
                  color: black2
              ),
            ]
        ),
        /// button theme
        headlineMedium: const TextStyle(
          fontSize: 20,
          color: black2,
          fontWeight: FontWeight.bold,
        )
    )
);



const activeLinearGradient =  LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  stops: [
    0.1,
    0.2,
    0.3,
    0.5,
    1
  ],
  colors: [
    gold,
    gold3,
    gold2,
    gold,
    gold
  ],
);