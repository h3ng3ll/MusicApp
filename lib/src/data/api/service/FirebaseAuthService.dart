// ignore_for_file: file_names


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_app/src/data/api/service/FirebaseFireStoreService.dart';
import 'package:music_app/src/data/exception/FirebaseAuthException.dart';
import 'package:music_app/src/domain/model/CurrentUser.dart';

class FirebaseAuthService {

  static  FirebaseAuthService _instance ()  => FirebaseAuthService._internal();

  factory FirebaseAuthService() => _instance();

  FirebaseAuthService._internal();

  static FirebaseAuth instance = FirebaseAuth.instance;

  static User? get user => instance.currentUser;

  static Future<void> registerUser ({
    required String email,
    required String password,
    required String fullName,
    required String userName,
  }) async {
    try {
       /// register user on FireBase
      await instance.createUserWithEmailAndPassword(
          email: email,
          password: password
      );

      CurrentUser cUser = CurrentUser(
          id:  user!.uid,
          userName: userName,
          fullName: fullName,
          email: email
      );

      /// initialize user on  Firestore .

      await FirebaseFireStoreService().signUpUserInitSetUp(cUser);

    } on FirebaseException catch (e) {
      throw Exception(e.message);
    }

  }


  static Future<void> logInUser ({
    String? email ,
    String? username ,
    required String password,
    required BuildContext context ,
  }) async  {

    if(email == null && username == null) {
      throw Exception ("username or email must be provided");
    }
    if(username != null){
      final foundEmail = await FirebaseFireStoreService().findEmailByUserName(username);
      if(foundEmail == null) {
         throw Exception("Such user is not exists");
      }else {
        email = foundEmail;
      }
    }
      try {
        await instance.signInWithEmailAndPassword(email: email!, password: password);
      } on Exception catch (e) {

        // ignore: use_build_context_synchronously
        throw FirebaseAuthExceptionHandler.signInWithEmailAndPassword(e as FirebaseAuthException , context);
      }

  }

}