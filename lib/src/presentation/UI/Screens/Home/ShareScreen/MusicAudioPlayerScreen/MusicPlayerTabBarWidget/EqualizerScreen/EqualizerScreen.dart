// ignore_for_file: file_names
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/src/data/bloc/EqualizerBloc/equalizer_bloc.dart';

import 'package:music_app/src/data/provider/AudioProvider.dart';
import 'package:music_app/src/presentation/UI/Screens/Home/ShareScreen/MusicAudioPlayerScreen/MusicPlayerTabBarWidget/EqualizerScreen/widget/BuildEQFrame.dart';
import 'package:music_app/src/presentation/UI/Screens/Home/ShareScreen/MusicAudioPlayerScreen/MusicPlayerTabBarWidget/EqualizerScreen/widget/BuildEQPresets.dart';
import 'package:music_app/src/presentation/UI/Screens/Home/ShareScreen/MusicAudioPlayerScreen/MusicPlayerTabBarWidget/EqualizerScreen/widget/BuildOnOffButton.dart';
import 'package:music_app/src/presentation/core/constants.dart';
import 'package:music_app/src/presentation/core/widgets/BuildHeaderTitle.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EqualizerScreen extends StatefulWidget {
  const EqualizerScreen({Key? key}) : super(key: key);

  @override
  State<EqualizerScreen> createState() => _EqualizerScreenState();
}

class _EqualizerScreenState extends State<EqualizerScreen> {


  double circularRadius = 7.5;

  final eqBloc = EqualizerBloc(AudioProvider.player.androidAudioSessionId);

  Future<bool> onWillPop() async {
    Navigator.pop(context , eqBloc.enabledEQ);
    return await Future.value(eqBloc.enabledEQ);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onWillPop(),
      child: Scaffold(
        body: SafeArea(
          child: BlocProvider(
            create: (context) => eqBloc,
            child: BlocBuilder<EqualizerBloc, EqualizerState>(
              builder: (context, state) {
                if(state is EqualizerLoadingState){
                  return const CircularProgressIndicator();
                }
                if (state is EqualizerLoadedState) {
                  return Column(
                    children: [
                      const Spacer(flex: 1,),

                      /// Equalizer   x
                      buildTitle(),
                      const Spacer(flex: 1,),

                      /// pressets On|Off button
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          children: [
                            BuildEQPresets(circularRadius: circularRadius),
                            const Spacer(),
                            const BuildOnOffButton(),
                          ],
                        ),
                      ),
                      const Spacer(flex: 3,),

                      const Expanded(
                          flex: 40,
                          child: BuildEQFrame()
                      ),
                      const Spacer(flex: 4,),

                      /// now can't be implemented
                      // /// Bass Boost  Virtualizer
                      // const BuildCircleSlider(),
                      const Spacer(flex: 2,),
                    ],
                  );
                } else{
                  return Container();
                }

              },
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTitle() {
    final dynSize = (size(context).height - size(context).width) / 8;

    return BuildHeaderTitle(
      beforeTitle: const [Spacer(flex: 2,)],
      title: AppLocalizations.of(context)!.equalizer,
      afterTitle: [
        const Spacer(),
        InkWell(
          onTap: () => onWillPop(),
          child: Image.asset(
            "assets/icons/close.png",
            height: dynSize,
            width: dynSize,
          ),
        )
      ],
    );
  }



}





