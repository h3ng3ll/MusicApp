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
    bool pastEnabledEQ =  audioProvider.enabledEQ;
    return InkWell(
        onTap: () async {
          final bool? futureEnabled = await  PersistentNavBarNavigator.pushDynamicScreen(
              context, screen: MaterialPageRoute(
                  builder: (context) =>    ChangeNotifierProvider.value(
                    value: audioProvider,
                    child: const EqualizerScreen(),
                  ),
              )
          );

          if(futureEnabled != null && pastEnabledEQ != futureEnabled ) {
            audioProvider.enabledEQ = futureEnabled;
            setState(() { });
          }
        },
        child: BuildAssetIcon(iconName: pastEnabledEQ ? "equalizerFilled" : "equalizer" )
    );
  }

}
