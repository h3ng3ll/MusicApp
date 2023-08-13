part of 'equalizer_bloc.dart';


abstract class EqualizerEvent {}

class EqualizerInvertEnableStatusEvent extends EqualizerEvent{}

class SlidingBandFreqEvent extends EqualizerEvent{

  final double value;
  final int freq;

  SlidingBandFreqEvent({required this.value , required this.freq});
}

class SetPresetEvent extends EqualizerEvent{

  final String preset;

  SetPresetEvent({required this.preset});
}




