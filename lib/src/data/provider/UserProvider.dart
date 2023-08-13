// ignore_for_file: file_names
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:music_app/src/data/repository/SongsRepository.dart';
import 'package:music_app/src/domain/model/CurrentUser.dart';
import 'package:music_app/src/domain/repository/Producer.dart';

class UserProvider  extends ChangeNotifier {

  static late  CurrentUser user ;

  /// streamControllers
  static StreamController<List<String>> followingStreamController = StreamController();
  static StreamController<String> avatarUrlStreamController = StreamController();

  /// Stream
  static  Stream<List<String>> followingStream = followingStreamController.stream.asBroadcastStream();
  static  Stream<String> avatarUrlStream = avatarUrlStreamController.stream.asBroadcastStream();

  UserProvider() {
    followingStream.listen((following) => user.following = following);
    avatarUrlStream.listen((url) => user.avatarUrl = url);
  }

  static void initialize (CurrentUser user ) => UserProvider.user = user;


  static Future<List<Producer>> fetchFollowingProducers (List<String>? uids) async {
    return await  Stream.fromIterable(uids ?? user.following)
        .asyncMap((uid) async => await SongsRepository.fetchProducerById(uid)).toList();
  }

}