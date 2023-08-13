// ignore_for_file: file_names


import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BuildTextFormField extends StatelessWidget {

  const BuildTextFormField({
    Key? key,
    this.obscure,
    this.hintText,
    this.validator,
    this.controller,
    this.onChanged,
    this.readOnly = false,
    this.textInputType = TextInputType.text,
    this.maxLength
  }) : super(key: key);

  final bool? obscure;
  final String? hintText;
  final String? Function (String?)? validator;
  final TextEditingController? controller;
  final void Function(String)? onChanged ;
  final bool readOnly ;
  final TextInputType textInputType;
  final int? maxLength ;

  @override
  Widget build(BuildContext context) {

    final hintStyle = Theme.of(context).textTheme.labelSmall!.copyWith(fontSize: 22);
    final textStyle = Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 22);

    return TextFormField(
      style: textStyle,
      controller: controller,
      maxLength: maxLength,
      obscureText: obscure ?? false,
      textInputAction: TextInputAction.next,
      obscuringCharacter: "*" ,
      onChanged:  onChanged,
      readOnly: readOnly ,
      keyboardType: textInputType,
      validator: (value) {
        /// handle default error states .
        if(value == null || value.isEmpty) {
          return AppLocalizations.of(context)!.this_field_must_not_be_empty;
        }
        if(validator != null) {
          return validator!(value);
        } else {
          return null;
        }

      },

      decoration: InputDecoration(
        counterText: "",
        hintText: hintText,
        // errorStyle: Tex,
        hintStyle: hintStyle,

        // label: Container(),
      ),
    );
  }
}
