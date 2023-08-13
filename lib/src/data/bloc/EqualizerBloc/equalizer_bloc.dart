// ignore_for_file: invalid_use_of_visible_for_testing_member, depend_on_referenced_packages

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equalizer_flutter/equalizer_flutter.dart';
import 'package:music_app/src/local/model/EQFreq.dart';
import 'package:music_app/src/local/model/EQPresets/EQClassical.dart';
import 'package:music_app/src/local/model/EQPresets/EQDance.dart';
import 'package:music_app/src/local/model/EQPresets/EQFlat.dart';
import 'package:music_app/src/local/model/EQPresets/EQHeavyMetal.dart';
import 'package:music_app/src/local/model/EQPresets/EQHipHop.dart';
import 'package:music_app/src/local/model/EQPresets/EQJazz.dart';
import 'package:music_app/src/local/model/EQPresets/EQNormal.dart';
import 'package:music_app/src/local/model/EQPresets/EQPop.dart';
import 'package:music_app/src/local/model/EQPresets/EQRock.dart';
import 'package:music_app/src/local/services/LocalStorageService.dart';

part 'equalizer_event.dart';
part 'equalizer_state.dart';

class EqualizerBloc extends Bloc<EqualizerEvent, EqualizerState> {


  final int? androidSessionID;

   

  /// Fields
  String presetName = "Normal";
  bool enabledEQ = false;
  late Map<String , dynamic> eqFreqs ;

  /// consts

  late final List<int> centerBandFreqs ;
  late final List<String> presetNames ;

  /// min -15
  /// max 15
  late final List<int> bandLevelRange ;

  /// Stream Controllers
  StreamController<bool> enabledEQStreamController = StreamController();
  StreamController<String> presetNameStreamController = StreamController();
  StreamController<Map<String , dynamic>> bandLevelRangeStreamController = StreamController();

  /// Streams
  late Stream<bool> enabledEQStream = enabledEQStreamController.stream.asBroadcastStream();
  late Stream<String> presetNameStream = presetNameStreamController.stream.asBroadcastStream();
  late Stream<Map<String , dynamic>> bandLevelRangeStream = bandLevelRangeStreamController.stream.asBroadcastStream();

  EqualizerBloc(this.androidSessionID) : super(EqualizerInitial()) {

    on<EqualizerInvertEnableStatusEvent>((event, emit) async {
      enabledEQ = !enabledEQ;

      enabledEQStreamController.sink.add(enabledEQ);
      await LocalStorageService.saveEqualizerStatus(enabledEQ);
      await EqualizerFlutter.setEnabled(enabledEQ);
    });

    on<SetPresetEvent>((event , emit) async {
      final preset = event.preset;

      /// value the same nothing do .
      if(preset != presetName) {
        presetName = preset;

        setPresetNameSettings(presetName);


        presetNameStreamController.sink.add(presetName);
        LocalStorageService.savePresetName(presetName);

        await EqualizerFlutter.setPreset(presetName);

      }

    });


    on<SlidingBandFreqEvent> ((event , emit) async {

      final value = event.value.toInt();
      final freq = event.freq;

      if(presetName != "Custom") {
        presetName =  "Custom";
        presetNameStreamController.sink.add(presetName);
      }
      else {
        presetName = defineEQAsset() ?? "Custom";
        presetNameStreamController.sink.add(presetName);
      }

      eqFreqs["fr_${freq~/1000}hz"]  = value;
      await LocalStorageService.saveCenterBandFreqsCache(eqFreqs);

      EqualizerFlutter.setBandLevel(1, centerBandFreqs.indexOf(freq));
    });

    initialize();
  }



  void initialize () async {
    emit(EqualizerLoadingState());

    if(androidSessionID == null) {
      emit(ProvidedNullAndroidSessionIDState());
      return;
    }
    /// Consts

    centerBandFreqs =  await EqualizerFlutter.getCenterBandFreqs();
    bandLevelRange = await EqualizerFlutter.getBandLevelRange();
    presetNames = await EqualizerFlutter.getPresetNames();

    /// Restore

    eqFreqs = await LocalStorageService.restoreCenterBandFreqsCache() ?? EQFreq.zero().toJson();
    enabledEQ = await LocalStorageService.restoreEqualizerStatus() ?? false;
    presetName = await LocalStorageService.restorePresetName() ?? "Normal";

    if(eqFreqs == EQFreq.zero().toJson()){
      presetName = "Normal";
    } else {
      presetName = "Custom";
    }



    emit(EqualizerLoadedState());
  }



  void setPresetNameSettings (String preset) {
    switch (preset) {
      case "Normal" :
        eqFreqs = const EQNormal().toJson();
      case "Classical" :
        eqFreqs = const EQClassical().toJson();
      case "Dance" :
        eqFreqs = const EQDance().toJson();
      case "Flat" :
        eqFreqs = const EQFlat().toJson();
      case "Heavy Metal" :
        eqFreqs = const EQHeavyMetal().toJson();
      case "Hip Hop" :
        eqFreqs = const EQHipHop().toJson();
      case "Jazz" :
        eqFreqs = const EQJazz().toJson();
      case "Pop" :
        eqFreqs = const EQPop().toJson();
    // return "Pop";
      case "Rock" :
        eqFreqs = const EQRock().toJson();
    }
  }

  String? defineEQAsset () {
    final f = EQFreq.fromJson(eqFreqs);

    if (f == const EQClassical()) {
      return "Classical";
    } else if (f == const EQDance()) {
      return "Dance";
    } else if (f == const EQFlat()){
      return "Flat";
    } else if (f == const EQHeavyMetal()){
      return "Heavy Metal";
    }else if (f == const EQHipHop()){
      return "Hip Hop";
    }else if (f == const EQJazz()){
      return "Jazz";
    }else if (f == const EQPop()){
      return "Pop";
    }else if (f == const EQRock()){
      return "Rock";
    }
    return null;
  }
}
