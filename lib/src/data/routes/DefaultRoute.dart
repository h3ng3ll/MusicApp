// ignore_for_file: file_names


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_app/src/data/api/service/FirebaseAuthService.dart';
import 'package:music_app/src/presentation/UI/Screens/Home/HomeTabBar.dart';
import 'package:music_app/src/presentation/UI/Screens/Login/InitScreen/InitScreen.dart';

class DefaultRoute extends StatelessWidget {
  const DefaultRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuthService.instance.userChanges(),
      builder: (context, snapshot) {
        final user = snapshot.data;

        if(user != null ) {
          return  const HomeTabBar();
        }
        else {
          return const InitScreen();
        }
      }
    );
  }
}
