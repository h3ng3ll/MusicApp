

import 'package:flutter/material.dart';
import 'package:music_app/src/data/routes/DefaultRoute.dart';
import 'package:music_app/src/presentation/UI/Screens/Home/HomeTabBar.dart';
import 'package:music_app/src/presentation/UI/Screens/Home/Tabs/HomeTab/AccountScreen/navigation/AboutScreen/AboutScreen.dart';
import 'package:music_app/src/presentation/UI/Screens/Home/Tabs/HomeTab/AccountScreen/navigation/NotificationsScreen/NotificationsScreen.dart';
import 'package:music_app/src/presentation/UI/Screens/Login/InitScreen/InitScreen.dart';

class AppRoutes {

  static const home = '/home'  ;
  static const login = '/login' ;
  static const player = '/player' ;


  static const aboutScreen = '$home/about';
  static const notificationsScreen = '$home/notifications';



  static Route? getRoute(RouteSettings settings) {
    switch(settings.name) {

      /// main routes
      case AppRoutes.home: return buildRoute(const HomeTabBar(), settings: settings);
      case AppRoutes.login: return buildRoute(const InitScreen(), settings: settings);

      case AppRoutes.aboutScreen: return buildRoute(const AboutScreen(), settings: settings);
      case AppRoutes.notificationsScreen: return buildRoute(const NotificationsScreen(), settings: settings);

      default: return buildRoute(const DefaultRoute(), settings: settings);
    }
  }

  static MaterialPageRoute buildRoute(Widget child , {required RouteSettings settings}){
    return MaterialPageRoute(
      settings: settings,
      builder: (context) => child,
    );
  }
}