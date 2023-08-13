// ignore_for_file: file_names


import 'package:flutter/material.dart';
import 'package:music_app/src/presentation/UI/Screens/Home/ShareScreen/MusicAudioPlayerScreen/MusicPlayerTabBarWidget/EqualizerScreen/paint/SliderEQThumbShape.dart';
import 'package:music_app/src/presentation/UI/Screens/Home/ShareScreen/MusicAudioPlayerScreen/MusicPlayerTabBarWidget/EqualizerScreen/paint/SliderEQTrackShape.dart';
import 'package:music_app/src/presentation/service/ColorService.dart';

class SliderEQTheme extends SliderThemeData {


  final bool enabled ;

  const SliderEQTheme({required this.enabled});

  @override
  SliderTrackShape? get trackShape => SliderEQTrackShape(enabledSlider: enabled);





  @override
  // TODO: implement thumbShape
  SliderComponentShape? get thumbShape => SliderEQThumbShape(enabled: enabled);

  @override
  // TODO: implement trackHeight
  double? get trackHeight => 15;
  
  @override
  // TODO: implement inactiveTrackColor
  Color? get inactiveTrackColor => grey3;

  @override
  // TODO: implement activeTrackColor
  Color? get activeTrackColor => gold;

  @override
  // TODO: implement thumbColor
  Color? get thumbColor => gold;
}