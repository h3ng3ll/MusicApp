// ignore_for_file: file_names




import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:music_app/src/data/api/service/FirebaseAuthService.dart';
import 'package:music_app/src/data/routes/app_routes.dart';
import 'package:music_app/src/presentation/UI/Screens/Login/InitScreen/RegisterFormScreen/widget/PasswordFormFieldWidget.dart';
import 'package:music_app/src/presentation/core/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:music_app/src/presentation/core/widgets/BuildAssetIcon.dart';
import 'package:music_app/src/presentation/core/widgets/BuildTextFormField.dart';
import 'package:music_app/src/presentation/core/widgets/ContainerGradient.dart';
import 'package:music_app/src/presentation/core/widgets/TextFormFieldContainer.dart';
import 'package:music_app/src/presentation/service/ColorService.dart';
import 'package:music_app/src/presentation/service/OverlayService.dart';

class LoginFormScreen extends StatefulWidget {
   const LoginFormScreen({Key? key}) : super(key: key);

  @override
  State<LoginFormScreen> createState() => _LoginFormScreenState();
}

class _LoginFormScreenState extends State<LoginFormScreen> with SingleTickerProviderStateMixin{

  /// Animation

  late final AnimationController? animationController;
  late final Animation<double>? animation ;

  /// form
  final formKey = GlobalKey<FormState>();

  /// textFieldControllers
  final emailOrUserNameController = TextEditingController();
  String password = "";

  bool nowAuthorizing = false;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this , duration: const Duration(seconds: 1));
    animation = CurveTween(curve: Curves.fastOutSlowIn).animate(animationController!);
  }

  @override
  void dispose() {
    animationController!.dispose();
    emailOrUserNameController.dispose();
    super.dispose();

  }
  void logInToAccount (BuildContext context) async {
    if(formKey.currentState!.validate()){

      if(nowAuthorizing) {
        return ;
      } else {
        nowAuthorizing = !nowAuthorizing;
      }

      final emailRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
      closeKeyboard();

      try {

        if(emailRegExp.hasMatch(emailOrUserNameController.text)){
          await FirebaseAuthService.logInUser(
              password: password ,
              email: emailOrUserNameController.text,
              context: context
          );
        } else {
          await FirebaseAuthService.logInUser(
              password: password ,
              username: emailOrUserNameController.text,
              context: context
          );
        }
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, AppRoutes.home);

      } on Exception catch (e) {
        nowAuthorizing = false;
       late String message ;
        if(e is FirebaseException) {
          message = e.message?? e.code;
        } else {
          message = e.toString();
        }
        // ignore: use_build_context_synchronously
        OverlayService().exceptionOverlay(
            context,
            message ,
            animation! ,
            animationController!
        );
      }
      // ignore: use_build_context_synchronously
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        reverse: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [

              SizedBox(height: size(context).height*0.05, ),
              buildTitle(context),
              SizedBox(height: size(context).height*0.02, ),

              buildForm(context),
              SizedBox(height: size(context).height*0.03, ),

              buildForgetPassword(context),
              SizedBox(height: size(context).height*0.05, ),

              buildLogInButton(context),
              SizedBox(height: size(context).height*0.03, ),

              buildOtherSignUpWays(context),


            ],
          ),
        ),
      ),
    );
  }

  Widget buildTitle(BuildContext context) {
    return const Row(
      children: [
        Spacer(),
        BuildAssetIcon(
          iconName: "close" ,
          size: 40,
        )
      ],
    );
  }

  Widget buildForm(BuildContext context) {

    final headlineLarge = Theme.of(context).textTheme.headlineLarge;

    return Form(
      key: formKey,
      child: Column(
        children: [
          Text(AppLocalizations.of(context)!.hey_welcome , style:  headlineLarge,),
          SizedBox(height: size(context).height*0.03, ),

          /// Email or Username
          TextFormFieldContainer(
            child: BuildTextFormField(
              controller: emailOrUserNameController,
              hintText: AppLocalizations.of(context)!.email_or_username,
            ),
          ),

          SizedBox(height: size(context).height*0.02, ),

          PasswordFormWidget(
            onChanged: (value) {
              if(value != null) password = value;
            },
          ),
          SizedBox(height: size(context).height*0.02, ),

        ],
      ),
    );

  }

  Widget buildForgetPassword (BuildContext context) {

    final theme = Theme.of(context).textTheme.labelSmall!.copyWith(fontSize: 22);
    return Align(
      alignment: Alignment.centerRight,
      child: InkWell(
          onTap: (){

          },
          child: Text(
              "${AppLocalizations.of(context)!.forget_password}?" ,
              style: theme,
          )
      ),
    );
  }

  Widget buildLogInButton(BuildContext context) {
     final buttonTheme = Theme.of(context).textTheme.headlineMedium;
     return Row(
       mainAxisAlignment: MainAxisAlignment.center,
       children: [
         InkWell(
           onTap: () => logInToAccount(context),
           child: ContainerGradient(
               boxShadow: buttonShadows(gold2 , gold9),
               circularRadius: 25,
               child: Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 35 , vertical: 10),
                 child: Text(AppLocalizations.of(context)!.log_in , style:  buttonTheme ,),
               )
           ),
         ),
       ],
     );
   }

  Widget buildOtherSignUpWays(BuildContext context) {

     final labelSmall = Theme.of(context).textTheme.labelSmall!.copyWith(fontSize: 20);

     return Column(
       children: [
         SizedBox(height: size(context).height*0.03, ),
         Text(AppLocalizations.of(context)!.or_continue_with , style:  labelSmall,),

         SizedBox(height: size(context).height*0.03, ),
         const Row(
           children: [
             Spacer(flex: 2,),
             BuildAssetIcon(iconName: "google" , size:  40,),
             Spacer(),
             BuildAssetIcon(iconName: "facebookCircle" , size:  40),
             Spacer(flex: 2,),
           ],
         ),

         SizedBox(height: size(context).height*0.03, ),
         Row(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             Text("${AppLocalizations.of(context)!.already_have_an_account}? " , style: labelSmall),
             InkWell(
               onTap: () {

               },
               child: Text(AppLocalizations.of(context)!.log_in , style: Theme.of(context).textTheme.displayMedium!.copyWith(fontSize: 20)),
             )
           ],
         )
       ],
     );
   }

  void closeKeyboard () {
    /// close keyboard if it open .

    // ignore: use_build_context_synchronously
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0 ;
    if(isKeyboardOpen ){
      // ignore: use_build_context_synchronously
      FocusScope.of(context).unfocus();
    }
  }
}
