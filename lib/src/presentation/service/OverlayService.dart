// ignore_for_file: file_names

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:music_app/src/domain/repository/Song.dart';
import 'package:music_app/src/presentation/UI/Screens/Home/ShareScreen/MusicAudioPlayerScreen/overlay/BuildPlayerOverlay.dart';

import 'package:music_app/src/presentation/core/widgets/ContainerGradient.dart';
import 'package:music_app/src/presentation/core/widgets/BuildAssetIcon.dart';
import 'package:music_app/src/presentation/core/constants.dart';
import 'package:music_app/src/presentation/service/ColorService.dart';
class OverlayService {

  static   OverlayService _instance () => OverlayService._internal();
  factory OverlayService () => _instance();

  OverlayService._internal(){
    // overlayVisibility.listen((status) => overlayVisible = status);
    overlayVisibility.listen((status) {
      overlayVisible = status;
      if(status == false ) {
        _overlayEntry?.remove();
        _overlayEntry = null ;
        // _overlayEntry?.dispose();
      }
    });
  }

  static OverlayEntry? _overlayEntry;
  static bool overlayVisible = false;

  /// Controllers
  static final _controller = StreamController<bool>();

  /// Streams
  static Stream<bool> overlayVisibility  = _controller.stream.asBroadcastStream();

  void closeOverlay () => _controller.add(false);


  Widget buildOverlayStyle (BuildContext context , {
    required Widget child ,
    /// take certain position on the screen
    bool? selfPositioned
  }) {

    Widget content () =>  Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(17.0),
        boxShadow: [
          BoxShadow(
              blurRadius: 2,
              color: black2.withOpacity(0.6),
              offset: const Offset(-10, 20)
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(17.0),
        child: Material(
          child: ContainerGradient(
            height: size(context).height/12,
            width: size(context).width,
            gradient: const LinearGradient(
                colors: [gold , gold2 , gold],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0 , 0.1 , 0.14 ,]
            ),
            child: child,
          ),
        ),
      ),
    );

    if(selfPositioned != null && selfPositioned == false) {
      return Stack(
        children: [
          Positioned(
              left: 20,
              right: 20,
              bottom: 68,
              child: content()
          ),
        ],
      );
    }else {
      return content();
    }
  }

  /// overlay Buildings
  Future<void> shareSongOverlay (BuildContext context ) async {

    OverlayState? overlayState = Overlay.of(context);

    _overlayEntry = OverlayEntry(builder: (context) {

      return buildOverlayStyle(
          context,
          selfPositioned: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                  onTap: () {
                    closeOverlay();
                  },
                  child: BuildAssetIcon(
                    iconName: "closeBlack",
                    size: size(context).width/10,
                  )
              ),
              InkWell(
                  onTap: () {

                  },
                  child: const BuildAssetIcon(iconName: "facebook")
              ),
              InkWell(
                  onTap: () {

                  },
                  child: const BuildAssetIcon(iconName: "twitter")
              ),
              InkWell(
                  onTap: () {

                  },
                  child: const BuildAssetIcon(iconName: "linkedIn")
              ),
              InkWell(
                  onTap: () {

                  },
                  child: const BuildAssetIcon(iconName: "instagram")
              ),
            ],
          )
      );
    });

    _controller.add(true);

    overlayState.insert(_overlayEntry!);

  }

  Future<void> playerOverlay (BuildContext context, { required  Song? song}) async {
    OverlayState? overlayState = Overlay.of(context);
    
    _overlayEntry = OverlayEntry(builder: (context) => BuildPlayerOverLay(
        song: song!,
    ));

    _controller.add(true);
    overlayState.insert(_overlayEntry!);
  }


  Future<void> exceptionOverlay (
      BuildContext context ,
      String message,
      Animation<double> animation,
      AnimationController animationController
      ) async {
    OverlayState? overlayState = Overlay.of(context);

    _overlayEntry =  OverlayEntry(
        builder: (context) => Stack(
          children: [
            Positioned(
              left: 20,
              right: 20,
              bottom: 68,
              child: FadeTransition(
                opacity: animation,
                child: buildOverlayStyle(
                  context,
                  selfPositioned: true,
                  child: FittedBox(child: Text(message))
                ),
              ),
            ),
          ],
        )
    );
    _controller.add(true);
    overlayState.insert(_overlayEntry!);
    animationController.forward();

    /// smooth hiding overlay
    Future.delayed(const Duration(seconds: 5))
        .whenComplete(() => animationController.reverse())
        .then((_) => closeOverlay());
  }
}