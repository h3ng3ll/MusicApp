// ignore_for_file: file_names



import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/src/data/bloc/EqualizerBloc/equalizer_bloc.dart';
import 'package:music_app/src/presentation/UI/Screens/Home/ShareScreen/MusicAudioPlayerScreen/MusicPlayerTabBarWidget/EqualizerScreen/widget/BuildSliderBand.dart';
import 'package:music_app/src/presentation/core/constants.dart';


class CustomEQ extends StatefulWidget {
  const CustomEQ({ required this.bandLevelRange, super.key});


  final List<int> bandLevelRange;

  @override
  // ignore: library_private_types_in_public_api
  _CustomEQState createState() => _CustomEQState();
}

class _CustomEQState extends State<CustomEQ> {
  late double min, max;

  int  bandId = 0 ;
  late StreamSubscription<String> subscription ;

  @override
  void initState() {
    super.initState();
    min = widget.bandLevelRange[0].toDouble();
    max = widget.bandLevelRange[1].toDouble();
    final bloc = BlocProvider.of<EqualizerBloc>(context , listen:  false);

    subscription = bloc.presetNameStream.listen((event) {
      setState(() { });
    });

  }

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
  }

  ///   *******************
  ///   *  15   * * * * * *
  ///   *  0    | | | | | *
  ///   * -15   | | | | | *
  ///   *******************

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<EqualizerBloc>(context );
    final frameHeight = size(context).height*0.4;

    const double padding = 15.0;


    return StreamBuilder<bool>(
        stream: bloc.enabledEQStream,
        builder: (context, snapshot) {
          final eqEnabled = snapshot.data ?? bloc.enabledEQ;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: padding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [

                      /// 15      0        -15
                      buildValueRanges(frameHeight , padding),


                      /// bands
                      buildBands( frameHeight , eqEnabled , padding),


                    ],
                  ),
                ),
              ),
            ],
          );
        }
    );
  }


  Widget buildValueRanges (double frameHeight , double padding) {
    return  Container(
      height: frameHeight,
      padding:  EdgeInsets.only(left: padding),
      child: Column(
        children: [
          Text("15" , style: Theme.of(context).textTheme.labelSmall,),
          const Spacer(),
          Text("0" , style: Theme.of(context).textTheme.labelSmall,),
          const Spacer(),
          Text("-15" , style: Theme.of(context).textTheme.labelSmall,),
        ],
      ),
    );

  }


  Widget buildBands ( double frameHeight , bool enabledEQ , double padding)  {

          final bloc = BlocProvider.of<EqualizerBloc>(context   , listen:  false);
          final centerBandFreqs = bloc.centerBandFreqs;
          final List<double> eqFreqs = bloc.eqFreqs.values.map((e) => (e as num).toDouble() ).toList();


    return Expanded(
      // height: frameHeight,
      // width: frameHeight,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          // padding: EdgeInsets.symmetric(horizontal: 70),
          itemCount: centerBandFreqs.length,
          itemBuilder: (context , i) {
            return BuildSliderBand(
              freq: centerBandFreqs[i],
              min: min,
              max: max,
              enabledEQ: enabledEQ,
              frameHeight: frameHeight,
              value: eqFreqs[i] ,
              // key: ,
            );
          }
      ),
    );
  }
}

