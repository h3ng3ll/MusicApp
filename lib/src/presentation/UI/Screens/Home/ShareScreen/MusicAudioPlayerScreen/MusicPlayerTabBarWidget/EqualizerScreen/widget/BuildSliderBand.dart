// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/src/data/bloc/EqualizerBloc/equalizer_bloc.dart';
import 'package:music_app/src/presentation/UI/Screens/Home/ShareScreen/MusicAudioPlayerScreen/MusicPlayerTabBarWidget/EqualizerScreen/paint/SliderEQTheme.dart';

// ignore: must_be_immutable
class BuildSliderBand extends StatefulWidget {
  final int freq ;
  final double min, max , frameHeight;
  final bool enabledEQ ;
  double value;

   BuildSliderBand({
    Key? key,
    required this.freq,
    required this.min,
    required this.max,
    required this.enabledEQ,
    required this.frameHeight,
    required this.value ,
  }) : super(key: key);

  @override
  State<BuildSliderBand> createState() => _BuildSliderBandState();
}

class _BuildSliderBandState extends State<BuildSliderBand> {


  String formatText() {
    final freq = widget.freq ~/ 1000;

    if(freq > 1000) {
      RegExp regex = RegExp(r'([.]*0)(?!.*\d)');
      /// remove .0 from  freq if it has this .
      final match = (freq/1000).toString().replaceAll(regex, '');
      return "${match}k";

    } else {
      return freq.toString();
    }

  }

  /// 60 Hz
  ///
  ///  O
  /// ||
  /// ||
  /// ||

  @override
  Widget build(BuildContext context) {

    final labelSmall = Theme.of(context).textTheme.labelSmall;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          Text('${formatText()} Hz' , style: labelSmall,),

          buildSlider(),

          Text(widget.value.round().toString() , style: Theme.of(context).textTheme.labelSmall,)

        ],
      ),
    );
  }

  Widget buildSlider () {

    final bloc = BlocProvider.of<EqualizerBloc>(context  , );

    return Expanded(
      child: RotatedBox(
        quarterTurns: 3,
        child: SliderTheme(

          data: SliderEQTheme(enabled: widget.enabledEQ),
          child: Slider(
            min: widget.min,
            max: widget.max,
            value: widget.value.toDouble(),
            onChanged: widget.enabledEQ ? (lowerValue){
              widget.value = lowerValue;
              bloc.add(SlidingBandFreqEvent(
                  freq: widget.freq,
                  value: lowerValue
              ));
              setState(() { });
            } : null,
          ),
        ),
      ),
    );
  }
}


