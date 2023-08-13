// ignore_for_file: file_names

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/src/data/provider/AudioProvider.dart';
import 'package:music_app/src/presentation/UI/Screens/Home/ShareScreen/MusicAudioPlayerScreen/MusicPlayerTabBarWidget/EqualizerScreen/widget/BuildCircleSlider/CustomCircularSliderAppearance.dart';
import 'package:music_app/src/presentation/core/constants.dart';
import 'package:provider/provider.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BuildCircleSlider extends StatefulWidget {
  const BuildCircleSlider({Key? key}) : super(key: key);

  @override
  State<BuildCircleSlider> createState() => _BuildCircleSliderState();
}

class _BuildCircleSliderState extends State<BuildCircleSlider> {

  final bassBooster = AndroidLoudnessEnhancer();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AudioProvider>(context );

    final enabled = !provider.enabledEQ;

    final titleMedium = enabled ?
    Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 25) :
    Theme.of(context).textTheme.titleMedium;


    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(pi),
              child: SleekCircularSlider(
                appearance: CustomCircularSliderAppearance(
                    darkenInactive: enabled,
                    size: dynSize(context)/4,
                ),
                innerWidget: (_) {
                  return Container();
                },
                onChange:  enabled  ?  null :  (double value ) async{
                  if(!bassBooster.enabled){
                    await bassBooster.setEnabled(true);
                  }
                  await bassBooster.setTargetGain(value);
                },
              ),
            ),
            SizedBox(height: size(context).height*0.02,),
            Text(AppLocalizations.of(context)!.bass_boost , style:  titleMedium)
          ],
        ),

        Column(
          children: [
            SleekCircularSlider(
              appearance: CustomCircularSliderAppearance(
                  size: dynSize(context)/4,
                  darkenInactive: enabled,

              ),
              innerWidget: (_) {
                return Container();
              },
              onChange: enabled  ?  null : (double value ) {

              },
            ),
            SizedBox(height: size(context).height*0.02,),
            Text(AppLocalizations.of(context)!.virtualizer , style:  titleMedium,)

          ],
        ),

      ],
    );
  }
}
