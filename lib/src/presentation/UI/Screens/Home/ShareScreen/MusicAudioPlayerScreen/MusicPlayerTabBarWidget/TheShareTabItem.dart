// ignore_for_file: file_names


import 'package:flutter/material.dart';
import 'package:music_app/src/presentation/core/widgets/BuildAssetIcon.dart';
import 'package:music_app/src/presentation/service/OverlayService.dart';

class TheShareTabItem extends StatefulWidget {
  const TheShareTabItem({Key? key}) : super(key: key);

  @override
  State<TheShareTabItem> createState() => _TheShareTabItemState();
}

class _TheShareTabItemState extends State<TheShareTabItem> with SingleTickerProviderStateMixin{

  late final AnimationController animationController ;
  late final Animation<double> animation ;
  @override
  void initState() {
    animationController = AnimationController(vsync: this , duration: const Duration(seconds: 300));
    animation = CurveTween(curve: Curves.fastOutSlowIn ).animate(animationController);

    super.initState();
  }
  @override
  void dispose() {
    animationController.dispose();
    OverlayService.overlayVisibility.distinct();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return InkWell(
        onTap: () async {

           if(OverlayService.overlayVisible ) {
             /// close overlay
             OverlayService().closeOverlay();
           }
           else {
             /// call overlay
             await OverlayService().shareSongOverlay(context);

           }
        },
        child:  StreamBuilder(
            stream: OverlayService.overlayVisibility,
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              return BuildAssetIcon(
                  iconName: snapshot.data != null  && snapshot.data! ?  "share2" : "share"
              );
            },

        )
    );
  }
}
