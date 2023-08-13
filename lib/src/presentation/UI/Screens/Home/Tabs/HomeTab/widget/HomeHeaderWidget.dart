// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:music_app/src/data/provider/UserProvider.dart';
import 'package:music_app/src/presentation/UI/Screens/Home/Tabs/HomeTab/AccountScreen/AccountScreen.dart';
import 'package:music_app/src/presentation/UI/Screens/Home/Tabs/HomeTab/widget/UserAvatar.dart';
import 'package:music_app/src/presentation/core/widgets/BuildHeaderTitle.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class HomeHeaderWidget extends StatelessWidget {
  const HomeHeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const iconHeight = 30.0;

    return BuildHeaderTitle(
      title: AppLocalizations.of(context)!.home,
      beforeTitle: [buildAvatar(context)],
      afterTitle: [buildImages(iconHeight)],
    );
  }

  Widget buildImages(double height) => Row(
        children: [
          arrowUpButton(height),
          const SizedBox(
            width: 20,
          ),
          notificationsButton(height)
        ],
      );

  Widget buildAvatar(BuildContext context) {

    return InkWell(
      onTap: () {
        PersistentNavBarNavigator.pushDynamicScreen(context,
            screen: MaterialPageRoute(
              builder: (context) => const AccountScreen()
            ),
            withNavBar: false
        );
      },
      child: StreamBuilder<String>(
          stream: UserProvider.avatarUrlStream,
          builder: (context, snapshot) {
            final avatar = snapshot.data ??  UserProvider.user.avatarUrl;
            return UserAvatar(imgUrl: avatar);
          }
      ),
    );
  }

  Widget arrowUpButton(double height) => InkWell(
        onTap: () async {
        },
        child: Image.asset(
          "assets/icons/arrowUp.png",
          height: height,
        ),
      );

  /// it'll showing new notifications .
  Widget notificationsButton(double height) => Image.asset(
        "assets/icons/notifications.png",
        height: height,
      );
}
