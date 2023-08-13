// ignore_for_file: file_names
import 'package:equalizer_flutter/equalizer_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/src/data/bloc/EqualizerBloc/equalizer_bloc.dart';
import 'package:music_app/src/presentation/core/constants.dart';
import 'package:music_app/src/presentation/core/widgets/BuildAssetIcon.dart';
import 'package:music_app/src/presentation/core/widgets/ContainerGradient.dart';
import 'package:music_app/src/presentation/service/ColorService.dart';

class BuildEQPresets extends StatefulWidget {

  final double circularRadius;

  const BuildEQPresets({
    Key? key,
    required this.circularRadius
  }) : super(key: key);

  @override
  State<BuildEQPresets> createState() => _BuildEQPresetsState();
}

class _BuildEQPresetsState extends State<BuildEQPresets> {

  late bool enabled ;

  @override
  void initState() {
    super.initState();
    final bloc = BlocProvider.of<EqualizerBloc>(context , listen:  false);
    enabled = bloc.enabledEQ;
    bloc.enabledEQStream.listen((event) { setState(() => enabled = event );  });
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<EqualizerBloc>(context , listen:  false);

    return StreamBuilder<String>(
        stream: bloc.presetNameStream,
        builder: (context, snapshot) {

          final presetName = snapshot.data ?? bloc.presetName;
          late List<String> presets ;

          if(!bloc.presetNames.contains(presetName)) {

            presets = [presetName , ...bloc.presetNames];
          } else {
            presets = bloc.presetNames;
          }

          return buildButton(
              presetName: presetName,
              items: presets,
              eqEnabled: enabled,
              context: context
          );
        }
    );
  }

  Widget buildButton ({
    required String presetName,
    required List<String> items,
    required bool eqEnabled,
    required BuildContext context,
  }) {

    final bodyMedium = Theme
        .of(context)
        .textTheme
        .bodyMedium;
    final titleMedium = Theme
        .of(context)
        .textTheme
        .titleMedium;

    Widget gradient ({required Widget child}) => eqEnabled ?
    ContainerGradient(circularRadius: widget.circularRadius, boxShadow: buttonShadows(), child: child ,) :
    ContainerGradient.dark(circularRadius: widget.circularRadius, boxShadow: buttonShadows(), child: child);



    return gradient(
      child: DropdownButton(
        underline: Container(),
        value: presetName,
        dropdownColor: gold,
        icon: BuildAssetIcon(
          iconName: eqEnabled ? "dropDownIcon" : "dropDownIconGold",
          size: dynSize(context) / 16,
        ),
        items: items.map((effect) {
          return DropdownMenuItem(
              value: effect,
              child: Text(
                effect,
                style: eqEnabled ?
                bodyMedium :
                titleMedium ,
              )
          );
        }).toList(),
        onChanged: eqEnabled ? (String? value) {
          if (value != null) {
            final bloc = BlocProvider.of<EqualizerBloc>(context , listen:  false);
            bloc.add(SetPresetEvent(preset: value));
            EqualizerFlutter.setPreset(value);
            // provider.presetName = value;
            setState(() {});
          }
        } : null,

      ),
    );
  }
}
