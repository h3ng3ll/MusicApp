// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:music_app/src/presentation/UI/Screens/Home/ShareScreen/MusicAudioPlayerScreen/MusicPlayerTabBarWidget/EqualizerScreen/EqualizerScreen.dart';
import 'package:music_app/src/presentation/UI/Screens/Home/widget/TabViewWidget.dart';
import 'package:music_app/src/presentation/UI/Screens/Home/ShareScreen/MusicAudioPlayerScreen/MusicPlayerTabBarWidget/TheLikeTabItem.dart';
import 'package:music_app/src/presentation/UI/Screens/Home/ShareScreen/MusicAudioPlayerScreen/MusicPlayerTabBarWidget/TheShareTabItem.dart';
import 'package:music_app/src/presentation/core/widgets/BuildAssetIcon.dart';
import 'package:music_app/src/data/provider/AudioProvider.dart';
import 'package:music_app/src/presentation/service/ColorService.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';

class MusicPlayerTabBarWidget extends StatefulWidget {

  const MusicPlayerTabBarWidget({Key? key}) : super(key: key);

  @override
  State<MusicPlayerTabBarWidget> createState() => _MusicPlayerTabBarWidgetState();
}

class _MusicPlayerTabBarWidgetState extends State<MusicPlayerTabBarWidget> {


  late bool enabledEQ ;


  @override
  void initState() {
    super.initState();
    enabledEQ = Provider.of<AudioProvider>(context , listen: false).enabledEQ;
  }

  @override
  Widget build(BuildContext context) {

    return TabViewWidget(
        items: [
          const TheLikeTabItem(),
          buildEqualizerTab(context),
          const TheShareTabItem(),
        ]
    );
  }


  // List<PersistentBottomNavBarItem> navBarItems () {
  //
  //   return [
  //     PersistentBottomNavBarItem(
  //         icon: const BuildAssetIcon( iconName: "like2",),
  //         inactiveIcon:  const BuildAssetIcon( iconName: "like",)
  //     ),
  //     PersistentBottomNavBarItem(
  //       icon: const BuildAssetIcon( iconName: "equalizer",),
  //       inactiveIcon: const BuildAssetIcon( iconName: "equalizer",),
  //     ),
  //     PersistentBottomNavBarItem(
  //       icon: const BuildAssetIcon( iconName: "share",),
  //       inactiveIcon:  const BuildAssetIcon( iconName: "share2",),
  //     ),
  //   ];
  // }

  Widget buildSplashLine () => Align(
    alignment: const Alignment(0.0 , -1),
    child: ClipOval(
      child: Container(
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                spreadRadius: 20,
                color: white,
              ),
            ]
        ),
        width: 150,
        height: 3,
      ),
    ),
  );

  Widget buildEqualizerTab(BuildContext context) {
    final audioProvider = Provider.of<AudioProvider>(context , listen:  false ) ;

    return InkWell(
        onTap: () async {
          final bool enabled = await  PersistentNavBarNavigator.pushDynamicScreen(
              context, screen: MaterialPageRoute(
                  builder: (context) =>    ChangeNotifierProvider.value(
                    value: audioProvider,
                    child: const EqualizerScreen(),
                  ),
              )
          );
          enabledEQ = enabled;
           // ignore: use_build_context_synchronously
           Provider.of<AudioProvider>(context , listen: false).enabledEQ = enabledEQ;
          setState(() { });
        },
        child: BuildAssetIcon(iconName: enabledEQ ? "equalizerFilled" : "equalizer" )
    );
  }

}
