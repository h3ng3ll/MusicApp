// ignore_for_file: file_names



import 'dart:io';

import 'package:flutter/material.dart';
import 'package:music_app/l10n/L10n.dart';
import 'package:music_app/src/data/api/service/FirebaseFireStoreService.dart';
import 'package:music_app/src/data/api/service/FirebaseStorageService.dart';
import 'package:music_app/src/data/provider/UserProvider.dart';
import 'package:music_app/src/domain/model/CurrentUser.dart';
import 'package:music_app/src/presentation/UI/Screens/Home/Tabs/HomeTab/AccountScreen/EditProfileScreen/widget/BuildBirthdayFormField.dart';
import 'package:music_app/src/presentation/core/constants.dart';
import 'package:music_app/src/presentation/core/widgets/BuildAvatarImage.dart';
import 'package:music_app/src/presentation/core/widgets/BuildHeaderTitle.dart';
import 'package:music_app/src/presentation/core/widgets/BuildTextFormField.dart';
import 'package:music_app/src/presentation/core/widgets/ContainerGradient.dart';
import 'package:music_app/src/presentation/core/widgets/TextFormFieldContainer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:music_app/src/presentation/service/ColorService.dart';
import 'package:music_app/src/presentation/service/ImagePickerService.dart';
import 'package:music_app/src/presentation/service/OverlayService.dart';

class EditProfileScreen extends StatefulWidget {
  final  CurrentUser user;
  final Function () update;
   const EditProfileScreen({Key? key, required this.user, required this.update}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> with SingleTickerProviderStateMixin{


  /// user's avatar .
  File? localAvatar ;

  /// Animation .

  late final  AnimationController animationController ;
  late final Animation<double> animation ;

  /// textField controllers .
  final  usernameController = TextEditingController();
  final  emailController = TextEditingController();
  DateTime? birthday ;

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this , duration: const Duration(seconds: 1));
    animation = CurveTween(curve: Curves.fastOutSlowIn ).animate(animationController);

    usernameController.text = widget.user.userName;
    emailController.text = widget.user.email;
  }

  void saveButton(BuildContext context) async {
    try {
      if(formKey.currentState!.validate()) {

        if(localAvatar != null) {
          final path = await FireBaseStorageService.storeAvatarImage(
              widget.user.id,
              localAvatar!
          );
          widget.user.avatarUrl = path;
          if(path != null) {
            UserProvider.avatarUrlStreamController.sink.add(path);
          }
          await FirebaseFireStoreService().updateUsersCredentials(widget.user);
        }

        widget.user.birthday = birthday;

        /// check username for availability .
        if (widget.user.userName != usernameController.text) {
          final bool available = await FirebaseFireStoreService()
              .checkAvailableUserName(usernameController.text);
          if (available) {
            widget.user.userName = usernameController.text;
          }
        }

        await FirebaseFireStoreService().updateUsersCredentials(widget.user);
        // ignore: use_build_context_synchronously
        OverlayService().exceptionOverlay(context, "The dates successfully  saved", animation, animationController);

      }



      } on Exception catch (e) {
        // ignore: use_build_context_synchronously
        OverlayService().exceptionOverlay(context, "Something went wrong $e", animation, animationController);
      }


  }

  @override
  Widget build(BuildContext context) {

    final textStyle = Theme.of(context).textTheme;
    final titleStyle = textStyle.titleMedium!.copyWith(color: white.withOpacity(0.3));
    final hintStyle = textStyle.labelSmall!.copyWith(fontSize: 20 , );

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Form(
          key: formKey,
          child: ListView(
            physics: const ScrollPhysics(),
            children: [

              BuildHeaderTitle(title: AppLocalizations.of(context)!.edit_profile),
              SizedBox(height: size(context).height*0.05),

              buildAvatarImage(),
              SizedBox(height: size(context).height*0.05),

              /// Username

              Text(AppLocalizations.of(context)!.username , style:titleStyle, ),
              SizedBox(height: size(context).height*0.01),

              TextFormFieldContainer(
                  child: BuildTextFormField(
                    hintText: AppLocalizations.of(context)!.username,
                    controller: usernameController,
                  )
              ),
              SizedBox(height: size(context).height*0.03),

              /// Email

              Text(AppLocalizations.of(context)!.email , style:titleStyle, ),
              SizedBox(height: size(context).height*0.01),

              TextFormFieldContainer(
                  child: BuildTextFormField(
                    readOnly: true,
                    hintText: AppLocalizations.of(context)!.email,
                    controller: emailController,
                  )
              ),
              SizedBox(height: size(context).height*0.03),

              /// Birthday

              BuildBirthdayFormField(
                  updateBirthday: (DateTime birthday) => this.birthday = birthday ,
                  initValue: widget.user.birthday,
              ),
              SizedBox(height: size(context).height*0.03),

              // buildLanguageField(),

              Text(AppLocalizations.of(context)!.language , style:titleStyle, ),
              SizedBox(height: size(context).height*0.01),

              TextFormFieldContainer(
                  child: DropdownButton<dynamic>(
                      dropdownColor: grey3,
                      underline: Container(),
                      style: hintStyle,
                      items: Languages.values.map((lang) => DropdownMenuItem(
                          child: Text(lang.name)
                      )).toList(),
                      onChanged: (item) {

                      }
                  )
              ),
              SizedBox(height: size(context).height*0.05),
              // buildSaveButton(),

              buildSaveButton(context),

              SizedBox(height: size(context).height*0.05),



            ],
          ),
        ),
      )
    );
  }

  Widget buildAvatarImage () {
    return SizedBox(
      child: InkWell(
          onTap: () async {
            final file  = await ImagePickerService().pickImage(context);
            if(file == null) return ;

            localAvatar = file ;
            setState(() {});
          },
          child: localAvatar != null ?
                  BuildAvatarImage(file: localAvatar,) :
                  BuildAvatarImage(imgUrl: widget.user.avatarUrl,)
      ),
    );
  }

  Widget buildSaveButton(BuildContext context) {

    final buttonTheme = Theme.of(context).textTheme.headlineMedium!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () async => saveButton(context),
          child: ContainerGradient(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35 , vertical: 10),
                child: Text(  AppLocalizations.of(context)!.save , style: buttonTheme,),
              )
          ),
        ),
      ],
    );
  }

  // Widget buildLanguageField() {
  //
  //   final textStyle = Theme.of(context).textTheme;
  //   final titleStyle = textStyle.titleMedium;
  //   final hintStyle = textStyle.labelSmall!.copyWith(fontSize: 20);
  //
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //
  //     ],
  //   );
  // }
  //
  // Widget buildSaveButton() {
  //   final buttonTheme = Theme.of(context).textTheme.headlineMedium!;
  //
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceAround,
  //     children: [
  //
  //     ],
  //   );
  // }


}
