// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/src/data/bloc/EqualizerBloc/equalizer_bloc.dart';
import 'package:music_app/src/presentation/core/constants.dart';
import 'package:music_app/src/presentation/core/widgets/ContainerGradient.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class BuildOnOffButton extends StatefulWidget {
  const BuildOnOffButton({Key? key,}) : super(key: key);

  @override
  State<BuildOnOffButton> createState() => _BuildOnOffButtonsState();
}

class _BuildOnOffButtonsState extends State<BuildOnOffButton> {

  double circularRadius = 7.5;

  @override
  Widget build(BuildContext context) {
    final  bloc = BlocProvider.of<EqualizerBloc>(context , listen:  false);
    final enableEQ = bloc.enabledEQ ;

    return InkWell(
      onTap: () {
        bloc.add(EqualizerInvertEnableStatusEvent());
        setState(() { });
      },
      child: enableEQ ? buildOffButton() : buildOnButton(),
    );
  }

  Widget buildOffButton () {
    final titleMedium =  Theme.of(context).textTheme.titleMedium;

    return ContainerGradient.dark(
         boxShadow: buttonShadows(),
         circularRadius: circularRadius,
         child:  Center(
             child: Text(
                 AppLocalizations.of(context)!.off.toUpperCase() ,
                 style:  titleMedium
             )
         )
     );
  }

  Widget buildOnButton () {
    final bodyMedium =  Theme.of(context).textTheme.bodyMedium;

    return ContainerGradient(
         circularRadius: circularRadius,
         child: Center(
             child: Text(
                 AppLocalizations.of(context)!.on.toUpperCase(),
                 style:  bodyMedium
             )
         )
     );
  }
}
