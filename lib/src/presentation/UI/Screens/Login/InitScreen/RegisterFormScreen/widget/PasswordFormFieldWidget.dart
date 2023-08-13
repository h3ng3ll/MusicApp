// ignore_for_file: file_names


import 'package:flutter/material.dart';
import 'package:music_app/src/presentation/core/widgets/BuildAssetIcon.dart';
import 'package:music_app/src/presentation/core/widgets/BuildTextFormField.dart';
import 'package:music_app/src/presentation/core/widgets/TextFormFieldContainer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PasswordFormWidget extends StatefulWidget {
  const PasswordFormWidget({Key? key, required this.onChanged}) : super(key: key);

  final Function(String?) onChanged;
  @override
  State<PasswordFormWidget> createState() => _PasswordFormWidgetState();
}

class _PasswordFormWidgetState extends State<PasswordFormWidget> {


  bool  obscure = true;

  @override
  Widget build(BuildContext context) {
    return  TextFormFieldContainer(
        child: Stack(
          children: [
            BuildTextFormField(
              onChanged: widget.onChanged,
              validator: (value) {
                if(value!.length > 4 ) {
                  return null ;
                }
                return null;
              },
              hintText: AppLocalizations.of(context)!.password,
              obscure: obscure,
            ),
             buildHideButton()
          ],
        )
    );
  }

  Widget buildHideButton() => Positioned(
      right: 20,
      top: 7,
      child: InkWell(
          onTap: () => setState(() => obscure = !obscure),
          child: BuildAssetIcon(iconName: obscure ? "eyeCrossOut" : "eye" , size: 37,)
      )
  );
}
