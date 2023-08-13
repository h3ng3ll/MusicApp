// ignore_for_file: file_names


import 'package:music_app/src/domain/model/CurrentUser.dart';

abstract class Database {

  Future<CurrentUser> fetchCurrentUser() ;
}