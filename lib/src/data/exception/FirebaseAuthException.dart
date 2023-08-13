// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FirebaseAuthExceptionHandler  {


  static Exception signInWithEmailAndPassword (FirebaseAuthException e , BuildContext context) {


    switch(e.message){

    /// [firebase_auth/wrong-password] The password is invalid or the user does not have a password.
      case "The password is invalid or the user does not have a password." :
        return Exception(AppLocalizations.of(context)!.
        invalid_email_username_or_password);

      /// [firebase_auth/too-many-requests] We have blocked all requests from this device due to unusual activity. Try again later.
      case "We have blocked all requests from this device due to unusual activity. Try again later.":
        return Exception(AppLocalizations.of(context)!.
        too_many_requests_try_later);

      default: return e;
    }
  }
}