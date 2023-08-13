// ignore_for_file: file_names

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';

class FireBaseStorageService {

  static final FireBaseStorageService _instance = FireBaseStorageService._internal();

  factory FireBaseStorageService() => _instance;

  FireBaseStorageService._internal();

  static final FirebaseStorage instance = FirebaseStorage.instance;


  Future<String> getImage () async {
    final a = await instance.ref().child("public/songs/all/Beast In Black - Blind and frozen.mp3").getDownloadURL();
    debugPrint("got uploaded url $a");
    return a;
  }

  static Future<String?> storeAvatarImage (String uid , File file) async {
    final ref = instance.ref().child("users/$uid/avatar");
    final list  = await ref.listAll();

    final name = "avatar${list.items.length+1}${extension(file.path)}";

    try {
      final res = await ref.child(name).putFile(file);
      return await res.ref.getDownloadURL();
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
    return null;

  }
}