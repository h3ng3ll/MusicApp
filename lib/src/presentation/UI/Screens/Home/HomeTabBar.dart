// ignore_for_file: file_names



import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:music_app/src/data/provider/AudioProvider.dart';
import 'package:music_app/src/data/provider/LibraryProvider.dart';
import 'package:music_app/src/data/provider/UserProvider.dart';
import 'package:music_app/src/data/repository/UserRepository.dart';
import 'package:music_app/src/domain/model/CurrentUser.dart';
import 'package:music_app/src/presentation/UI/Screens/Home/Tabs/HomeTab/HomeTab.dart';
import 'package:music_app/src/presentation/UI/Screens/Home/Tabs/LibraryTab/LibraryTab.dart';
import 'package:music_app/src/presentation/UI/Screens/Home/Tabs/SearchTab/SearchScreen.dart';
import 'package:music_app/src/presentation/UI/Screens/Home/widget/BuildTabBar.dart';
import 'package:music_app/src/presentation/service/ColorService.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';

class HomeTabBar extends StatefulWidget {
   const HomeTabBar({Key? key}) : super(key: key);

  @override
  State<HomeTabBar> createState() => _HomeTabBarState();
}

class _HomeTabBarState extends State<HomeTabBar> {

  late StreamSubscription<bool> keyboardSubscription;

   bool visibleBar = true;
   final controller = PersistentTabController();

   @override
   void initState() {
     super.initState();
     var keyboardVisibilityController = KeyboardVisibilityController();
     keyboardSubscription  = keyboardVisibilityController.onChange.listen((bool visible) {
       visibleBar = !visible;
     });
   }

   @override
  void dispose() {
     keyboardSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AudioProvider(context)),
        ChangeNotifierProvider(create: (context) => LibraryProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
      ],
      child: buildLayer()
    );
  }

  Widget buildLayer () {

    return FutureBuilder<CurrentUser>(
        future: UserRepository.fetchCurrentUser(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.done && snapshot.data != null){
            UserProvider.initialize(snapshot.data!);

            return Scaffold(
              body: PersistentTabView.custom(
                context,
                hideNavigationBar: !visibleBar,
                backgroundColor: transparent,
                controller: controller,
                onWillPop: (_) async => false,
                screens: screens(),
                customWidget: BuildTabBar(
                  isVisible: visibleBar,
                  callBack: (int index) {
                    controller.jumpToTab(index);
                  },
                  activeIndex: controller.index,
                ),
                itemCount: screens().length,
                // items: items,
              ),
            );

          } else {
            return const Center(child: CircularProgressIndicator());
          }
        }
    );

  }

  List<Widget > screens () =>  [
    const HomeTab(),
     const SearchScreen(),
    const LibraryTab(),

  ].map((e) => Scaffold(
    body: SafeArea(
      child: e,),
    )
  ).toList();

}


