// ignore_for_file: file_names


import 'package:flutter/material.dart';
import 'package:music_app/src/presentation/core/defaultTheme.dart';
import 'package:music_app/src/presentation/service/ColorService.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class CustomCircularSliderAppearance extends CircularSliderAppearance{

  final bool darkenInactive;

  CustomCircularSliderAppearance({
   required double size  ,
   this.darkenInactive = false
  }) : super(
      size:  size ,
      animationEnabled: darkenInactive
  );

  @override
  List<Color> get progressBarColors => darkenInactive ? [grey , grey] :  activeLinearGradient.colors;

  @override
  Color get trackColor => grey3;

  @override
  double get startAngle => 110;

  @override
  // // TODO: implement angleRange
  double get angleRange => 320;

  @override
  // TODO: implement counterClockwise
  bool get counterClockwise => false;

  @override
  // TODO: implement animationEnabled
  bool get animationEnabled => true;

  @override
  // TODO: implement shadowStep
  double? get shadowStep => 2;

  @override
  // TODO: implement dotColor
  Color get dotColor => transparent;

  @override
  // TODO: implement shadowColor
  Color get shadowColor => darkenInactive ? transparent :  gold ;

  @override
  // // TODO: implement shadowWidth
  double get shadowWidth => darkenInactive ? 15 : 30;

  @override
  // TODO: implement shadowMaxOpacity
  double get shadowMaxOpacity => 0.2;



  @override
  // TODO: implement customWidths
  CustomSliderWidths? get customWidths => CustomSliderWidths(
    trackWidth:  7,
    progressBarWidth: 5,
    handlerSize: -5,
    shadowWidth: 9
  );


}