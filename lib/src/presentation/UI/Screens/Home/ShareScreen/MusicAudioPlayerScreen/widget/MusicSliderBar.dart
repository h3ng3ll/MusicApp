// ignore_for_file: file_names

import 'dart:math';

import 'package:flutter/material.dart';

class MusicSliderBar extends StatefulWidget {
  final Duration duration;
  final Duration position;
  final Duration bufferedPosition;
  final ValueChanged<Duration>? onChanged;
  final ValueChanged<Duration>? onChangeEnd;
  final EdgeInsets? padding ;

  const MusicSliderBar({
    Key? key,
    required this.duration,
    required this.position,
    required this.bufferedPosition,
    this.onChanged,
    this.onChangeEnd,
    this.padding,
  }) : super(key: key);

  @override
  MusicSliderBarState createState() => MusicSliderBarState();
}

class MusicSliderBarState extends State<MusicSliderBar> {
  double? _dragValue;



  @override
  Widget build(BuildContext context) {
        final  labelSmall = Theme.of(context).textTheme.labelSmall;
        final sliderThemeData = SliderTheme.of(context);

    return Padding(
      padding: widget.padding ?? EdgeInsets.zero,
      child: Row(
        children: [
          Text(
              RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                  .firstMatch("${widget.position}")
                  ?.group(1) ??
                  '${widget.position}',
              style: labelSmall
          ),
          SliderTheme(
            data: sliderThemeData.copyWith(),
            child: Expanded(
              child: Slider(

                min: 0.0,
                max: widget.duration.inMilliseconds.toDouble(),
                value: min(_dragValue ?? widget.position.inMilliseconds.toDouble(),
                    widget.duration.inMilliseconds.toDouble()),
                onChanged: (value) {
                  setState(() {
                    _dragValue = value;
                  });
                  if (widget.onChanged != null) {
                    widget.onChanged!(Duration(milliseconds: value.round()));
                  }
                },
                onChangeEnd: (value) {
                  if (widget.onChangeEnd != null) {
                    widget.onChangeEnd!(Duration(milliseconds: value.round()));
                  }
                  _dragValue = null;
                },
              ),
            ),
          ),

          Text(
              RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                  .firstMatch("${widget.duration}")
                  ?.group(1) ??
                  '${widget.duration}',
              style: labelSmall
          ),

        ],
      ),
    );
  }

}
