// ignore_for_file: file_names




import 'package:flutter/material.dart';
import 'package:music_app/src/presentation/service/ColorService.dart';

class SliderEQThumbShape extends RoundSliderThumbShape {

  final double radius ;
  final bool enabled ;
  SliderEQThumbShape({
     required this.enabled,
     this.radius =  15,
    double? elevation
  }) : super(elevation: elevation ?? 1);


  @override
  void paint(PaintingContext context, Offset center,
      {required Animation<double> activationAnimation,
      required Animation<double> enableAnimation,
      required bool isDiscrete,
      required TextPainter labelPainter,
      required RenderBox parentBox,
      required SliderThemeData sliderTheme,
      required TextDirection textDirection,
      required double value,
      required double textScaleFactor,
      required Size sizeWithOverflow}) {

    final canvas = context.canvas;


    if(enabled) {
      buildElevation(canvas , center);
      /// build  drop Shadow
      buildDropShadow(canvas , center);

      buildSphere(canvas , center);
    }else {
      /// build  drop Shadow
      buildDropShadow(canvas , center);

      buildSphere(canvas , center);
    }





  }


  void buildElevation (Canvas canvas , Offset center) {
    /// build elevation
    final  path = Path()..addOval( Rect.fromCircle(
      center: Offset(center.dx+8 , center.dy),
      radius: radius+ 5,

    ));
    canvas.drawShadow(path, gold, 4, true);
  }

  void buildSphere (Canvas canvas , Offset center) {

    final Rect trackRect = Rect.fromCircle(
      center: center,
      radius: radius,

    );


    RadialGradient gradient =  RadialGradient(
      tileMode: TileMode.clamp,

      stops: enabled ? [
        0.2 , 0.7,  0.85 , 1 ,
      ] : [
        0.0 , 0.7 , 1
      ],
        /// REMEMBER !!! the thumb should be rotated at 90 degree
      focal: const Alignment(0.25, 0.7),
        colors: enabled ?  [
          gold2 , gold17 , gold , gold18,
        ] : [
          white , grey  , black2
        ]
    );
    Paint paint = Paint()
      ..shader = gradient.createShader(trackRect)
      ..color = gold;
    /// build circle
    canvas.drawCircle(center, radius, paint);
  }

  void buildDropShadow (Canvas canvas , Offset center) {
    Paint paint = Paint()
      ..shader
      ..color = Colors.black.withOpacity(0.5);
    /// build circle
    canvas.drawCircle(
        Offset(
            center.dx + 5 ,
            center.dy + 1
        ),
        radius,
        paint
    );

  }
}