// ignore_for_file: file_names


import 'package:flutter/material.dart';
import 'package:music_app/src/data/api/service/FirebaseAuthService.dart';
import 'package:music_app/src/data/provider/UserProvider.dart';
import 'package:music_app/src/data/routes/app_routes.dart';
import 'package:music_app/src/domain/model/CurrentUser.dart';
import 'package:music_app/src/presentation/UI/Screens/Home/Tabs/HomeTab/AccountScreen/EditProfileScreen/EditProfileScreen.dart';
import 'package:music_app/src/presentation/core/widgets/ContainerGradient.dart';
import 'package:music_app/src/presentation/UI/Screens/Home/Tabs/HomeTab/AccountScreen/widget/BuildAccountNavigationItem.dart';
import 'package:music_app/src/presentation/UI/Screens/Home/Tabs/HomeTab/widget/UserAvatar.dart';
import 'package:music_app/src/presentation/core/widgets/BuildAssetIcon.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:music_app/src/presentation/core/constants.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class AccountScreen extends StatefulWidget {
   const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late CurrentUser user ;

  final List<String> navigationIcons = ["notificationsWhite",    "user",    "guard",    "star",  ];

   List<String> navigationTitles (BuildContext context) => [
     AppLocalizations.of(context)!.notifications,
     AppLocalizations.of(context)!.about,
     AppLocalizations.of(context)!.privacy_policy,
     AppLocalizations.of(context)!.rate_us,
  ];

  List<String> navigationRoutes  = [
     AppRoutes.notificationsScreen,
     AppRoutes.aboutScreen,
  ];

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context).textTheme;

    // final userProvider = Provider.of<UserProvider>(context , listen: false);
    user = UserProvider.user;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: size(context).height*0.05),
        child: Column(
          children: [

            SizedBox(height: size(context).height*0.05,),
            buildTitle(context),

            buildAccountMeta(theme , context),

            SizedBox(height: size(context).height*0.07,),
            buildFollowers ( context , theme ),

            SizedBox(height: size(context).height*0.07,),
            buildNavigation(),

            buildLogOutButton(context , theme),
            SizedBox(height:  size(context).height*0.05,)

          ],
        ),
      )
    );
  }

  Widget buildNavigation () {
    return   Expanded(
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: navigationTitles(context).length,
        itemBuilder: (context, index) {
          return Padding(
            padding:  EdgeInsets.only(bottom: size(context).height*0.05),
            child: BuildAccountNavigationItem(
                iconName: navigationIcons[index],
                title: navigationTitles(context)[index],
                onTap: index != 1 ? null : ()  {
                    Navigator.pushNamed(context, navigationRoutes[index]);
                }
            ),
          );
        },
      ),
    );
  }

  Widget buildTitle(BuildContext context) {

    final dSize = dynSize(context)/9;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
            onTap: () => PersistentNavBarNavigator.pushNewScreen(
              context,
              screen: EditProfileScreen(user: user, update: () => setState(() {}),)),
            child: BuildAssetIcon(iconName: "userEdit" , size: dSize,)
        ),
        InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: BuildAssetIcon(iconName: "close" , size: dSize)
        ),
      ],
    );
  }

  Widget buildAccountMeta(TextTheme theme , BuildContext context) {
    return Column(
      children: [
        StreamBuilder<String>(
          stream: UserProvider.avatarUrlStream,
          builder: (context, snapshot) {
            final avatar = snapshot.data ??  UserProvider.user.avatarUrl;
            return UserAvatar(imgUrl: avatar);
          }
        ),
        SizedBox(height: size(context).height*0.02,),
        Text(user.userName , style: theme.displayMedium?.copyWith(fontSize: 20),),
        Text(user.email , style: theme.labelSmall?.copyWith(fontSize: 20))
      ]
    );
  }

  Widget buildFollowers(BuildContext context , TextTheme theme) {

    final labelSmall = theme.labelSmall?.copyWith(fontSize: 22);
    final displayMedium = theme.displayMedium?.copyWith(fontSize: 20);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            Text(user.followers.length.toString() , style: displayMedium),
            SizedBox(height: size(context).height*0.01,),
            Text(
                AppLocalizations.of(context)!.followers ,
                style:  labelSmall
            )
          ],
        ),

        Column(
          children: [
            Text(user.following.length.toString() , style: displayMedium),
            SizedBox(height: size(context).height*0.01,),
            Text(
                AppLocalizations.of(context)!.following ,
                style:  labelSmall
            )
          ],
        ),
      ],
    );
  }

  Widget buildLogOutButton (BuildContext context  , TextTheme theme) {

    final buttonTheme = theme.headlineMedium;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () async {
            Navigator.pushReplacementNamed(context, AppRoutes.login);
            await FirebaseAuthService.instance.signOut();
          },
          child: ContainerGradient(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35 , vertical: 10),
                child: Text(  AppLocalizations.of(context)!.log_out , style: buttonTheme,),
              )
          ),
        ),
      ],
    );

  }
}
