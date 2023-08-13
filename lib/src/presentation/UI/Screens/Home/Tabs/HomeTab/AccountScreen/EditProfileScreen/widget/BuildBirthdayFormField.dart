// ignore_for_file: file_names




import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:music_app/src/presentation/core/constants.dart';
import 'package:music_app/src/presentation/core/widgets/BuildTextFormField.dart';
import 'package:music_app/src/presentation/core/widgets/TextFormFieldContainer.dart';
import 'package:music_app/src/presentation/service/ColorService.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class BuildBirthdayFormField extends StatefulWidget {
  const BuildBirthdayFormField({Key? key, required this.updateBirthday, this.initValue}) : super(key: key);

  final void Function(DateTime ) updateBirthday;
  final DateTime? initValue;
  @override
  State<BuildBirthdayFormField> createState() => _BuildBirthdayFormFieldState();

}

class _BuildBirthdayFormFieldState extends State<BuildBirthdayFormField> {

  final  birthdayController = TextEditingController();


  @override
  void initState() {
    super.initState();
    if (widget.initValue != null) {
      birthdayController.text = DateFormat('yyyy-MM-dd').format(widget.initValue!);
    }
  }
  
  String? validator (String? value) {
    final takenDate = DateTime.tryParse(birthdayController.text);
    if(takenDate == null) {
      return "Invalid format type of Date";
    }
    final differenceDates = takenDate.difference(DateTime.now()).inDays;
    if( differenceDates.abs()   < (365 * 5) ){
      return "Your have to have more 5 year";
    }
    else if ( differenceDates > 0 ){
      return "Your birthday can not be on the future";
    }
    return null;
  }

  void onChanged (String value) {
    if(birthdayController.text.length > 10) return ;

    final date = DateTime.tryParse(value);

    if(date != null) {
      birthdayController.text = DateFormat("yyyy-MM-d").format(date);
      widget.updateBirthday(date);
    }
  }

  @override
  Widget build(BuildContext context) {

    final titleStyle =  Theme.of(context).textTheme.titleMedium!.copyWith(color: white.withOpacity(0.3));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppLocalizations.of(context)!.birthday , style:titleStyle, ),
        SizedBox(height: size(context).height*0.01),

        TextFormFieldContainer(
            child: BuildTextFormField(
              hintText: AppLocalizations.of(context)!.birthday,
              controller: birthdayController,
              maxLength: 10,
              onChanged: onChanged,
              validator: validator,
              textInputType: TextInputType.number,
            )
        ),
      ],
    );
  }
}
