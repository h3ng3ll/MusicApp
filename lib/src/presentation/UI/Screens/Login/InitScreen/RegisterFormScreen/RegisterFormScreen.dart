// ignore_for_file: file_names


import 'package:flutter/material.dart';
import 'package:music_app/src/data/api/service/FirebaseAuthService.dart';
import 'package:music_app/src/data/api/service/FirebaseFireStoreService.dart';
import 'package:music_app/src/data/routes/app_routes.dart';
import 'package:music_app/src/presentation/UI/Screens/Login/InitScreen/RegisterFormScreen/widget/PasswordFormFieldWidget.dart';
import 'package:music_app/src/presentation/core/constants.dart';
import 'package:music_app/src/presentation/core/widgets/BuildAssetIcon.dart';
import 'package:music_app/src/presentation/core/widgets/BuildTextFormField.dart';
import 'package:music_app/src/presentation/core/widgets/ContainerGradient.dart';
import 'package:music_app/src/presentation/core/widgets/TextFormFieldContainer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:music_app/src/presentation/service/ColorService.dart';
import 'package:music_app/src/presentation/service/OverlayService.dart';

// ignore: must_be_immutable
class RegisterFormScreen extends StatefulWidget {
   const RegisterFormScreen({Key? key}) : super(key: key);

  @override
  State<RegisterFormScreen> createState() => _RegisterFormScreenState();
}

class _RegisterFormScreenState extends State<RegisterFormScreen> with SingleTickerProviderStateMixin{
   late final Animation<double> animation ;
   late final AnimationController controller ;

  final formKey = GlobalKey<FormState>();

  final fullNameController = TextEditingController();

  final userNameController = TextEditingController();

  final emailController = TextEditingController();

  String  password = "";

  @override
  void initState() {
    controller =     AnimationController(vsync: this , duration: const Duration(seconds: 1));
    animation = CurveTween(curve: Curves.fastOutSlowIn, ).animate(controller);
    super.initState();
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
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

              buildSignUpButton(context) ,
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
          Text(AppLocalizations.of(context)!.lets_get_started , style:  headlineLarge,),
          SizedBox(height: size(context).height*0.03, ),


          TextFormFieldContainer(
              child: BuildTextFormField(
                controller: fullNameController,
                validator: (value) {
                  if(value!.length < 2){
                    return AppLocalizations.of(context)!.give_more_text;
                  }
                  return null;
                },
                hintText: AppLocalizations.of(context)!.full_name,
              )
          ),
          SizedBox(height: size(context).height*0.02, ),

          /// UserName
          TextFormFieldContainer(
              child: BuildTextFormField(
                controller: userNameController,
                validator: (value) {
                  if(value!.length < 2){
                    return AppLocalizations.of(context)!.give_more_text;
                  }
                  return null;
                },
                hintText: AppLocalizations.of(context)!.username,
              )
          ),

          SizedBox(height: size(context).height*0.02, ),

          /// Email
          TextFormFieldContainer(
            child: BuildTextFormField(
              controller: emailController,
              validator: (value) {
                final emailRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                if(emailRegExp.hasMatch(value!)){
                  return null;
                } else {
                  return AppLocalizations.of(context)!.the_email_address_is_incorrect;
                }

              },
              hintText: AppLocalizations.of(context)!.email,
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

  Widget buildSignUpButton(BuildContext context) {
    final buttonTheme = Theme.of(context).textTheme.headlineMedium;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () async {
            if(formKey.currentState!.validate()){
              closeKeyboard();
              try {
              final isFreeUsername = await FirebaseFireStoreService().checkAvailableUserName(userNameController.text);
              if(!isFreeUsername) throw Exception("Username already taken by another user");


                await FirebaseAuthService.registerUser(
                    email: emailController.text,
                    password: password,
                    fullName: fullNameController.text,
                    userName: userNameController.text
                );

                // ignore: use_build_context_synchronously
                Navigator.of(context).pushReplacementNamed(AppRoutes.home);
              } catch  (e) {
                // ignore: use_build_context_synchronously
                OverlayService().exceptionOverlay(context, e.toString(), animation, controller);
              }

            }
          },
          child: ContainerGradient(
              boxShadow: buttonShadows(gold2 , gold9),
              circularRadius: 25,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35 , vertical: 10),
                child: Text(AppLocalizations.of(context)!.sign_up , style:  buttonTheme ,),
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
               child: Text(AppLocalizations.of(context)!.sign_up , style: Theme.of(context).textTheme.displayMedium!.copyWith(fontSize: 20)),
             )
           ],
         )
         // RichText(
         //   text: TextSpan(
         //       children: [
         //         TextSpan(text: "${AppLocalizations.of(context)!.already_have_an_account}? " , style: labelSmall),
         //         TextSpan(text: AppLocalizations.of(context)!.sign_up , style: Theme.of(context).textTheme.displayMedium!.copyWith(fontSize: 20)),
         //       ]
         //   ),
         // )
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
