// ignore_for_file: file_names


import 'package:flutter/material.dart';
import 'package:music_app/src/presentation/UI/Screens/Login/InitScreen/LoginFormScreen/LoginFormScreen.dart';
import 'package:music_app/src/presentation/UI/Screens/Login/InitScreen/RegisterFormScreen/RegisterFormScreen.dart';
import 'package:music_app/src/presentation/core/constants.dart';
import 'package:music_app/src/presentation/core/widgets/BuildScreenOffsetShadows.dart';
import 'package:music_app/src/presentation/core/widgets/ContainerGradient.dart';
import 'package:music_app/src/presentation/service/ColorService.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InitScreen extends StatelessWidget {
  const InitScreen({Key? key}) : super(key: key);

  void onLoginTap  (BuildContext context) => pushRoute(context, child:  const LoginFormScreen());

  void onSignUpTap  (BuildContext context) => pushRoute(context, child:  const RegisterFormScreen());

  @override
  Widget build(BuildContext context) {

    final style =  Theme.of(context).textTheme.headlineLarge;

    return buildImage(
      child: Column(
        children: [
          const Spacer(flex: 2,),
          Text(AppLocalizations.of(context)!.calm_your_soul_with_music , style: style , textAlign: TextAlign.center,),
          const Spacer(),
          buildLogInButton(context),
          SizedBox(height: size(context).height*0.03,),
          buildSignUpButton(context),
          const Spacer(flex: 5,),
        ],
      )
    );
  }

  Widget buildImage({required Widget child}) {
    return BuildScreenOffsetShadows(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            image: const  DecorationImage(
                image: AssetImage("assets/images/init_bg.png"),
                fit: BoxFit.cover
            )
        ),
        child: child,
      ),
    );
  }


  Widget buildLogInButton(BuildContext context) {
    final buttonTheme = Theme.of(context).textTheme.headlineMedium!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        InkWell(
          onTap: () => onLoginTap(context),
          child: ContainerGradient(
            boxShadow: buttonShadows(gold2 , gold9),
            circularRadius: 25,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35 , vertical: 10),
              child: Text(AppLocalizations.of(context)!.log_in , style:  buttonTheme,),
            )
          ),
        ),

      ],
    );
  }

  Widget buildSignUpButton(BuildContext context) {

    final buttonTheme = Theme.of(context).textTheme.headlineMedium!.copyWith(color: white);


    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        InkWell(
          onTap: () => onSignUpTap(context),
          child: ContainerGradient.dark(
              circularRadius: 25,
              boxShadow: buttonShadows(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35 , vertical: 10),
                child: Text(
                    AppLocalizations.of(context)!.sign_up,
                    style:  buttonTheme,
                ),
              ),
          ),
        ),

      ],
    );
  }
}
