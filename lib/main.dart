


import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_app/l10n/L10n.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:music_app/src/data/routes/app_routes.dart';
import 'package:music_app/src/presentation/core/defaultTheme.dart';
import 'package:music_app/src/presentation/service/ColorService.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  /// Portrait orientation ONLY
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp ,
    DeviceOrientation.portraitDown,
  ]);

  // Intent intent = new Intent("com.example.myapp.ACTION_SECOND_ACTIVITY");
  // startActivity(intent);

  /// Firebase Service
  await Firebase.initializeApp();

  /// Audio service background
 // try {
   await JustAudioBackground.init(
     androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
     androidNotificationChannelName: 'Audio playback',
     androidNotificationOngoing: true,
   );
 // // ignore: empty_catches
 // } on Exception {
 //
 // }




  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarColor: transparent
      )
  );


  runApp( const MyApp());
}

class MyApp extends StatefulWidget {
   const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  late StreamSubscription<User?>  subscription ;


  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove;
  }

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      supportedLocales: L10n.locals,
      theme: defaultTheme(context),
      // home: MyApp1(),
      initialRoute: "/",
      onGenerateRoute: (route) => AppRoutes.getRoute(route),
    );
  }
}
