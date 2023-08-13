// ignore_for_file: file_names


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:music_app/src/domain/model/CurrentUser.dart';

class ApiCurrentUser {

  static Future<CurrentUser> fromJson(Map<String, dynamic> json) async {
    return CurrentUser(
      id: json['id'],
      userName: json['userName'],
      fullName: json['fullName'],
      avatarUrl: json['avatarUrl'],
      email: json['email'],
      followers: List<String>.from(json['followers'] ?? []),
      following: List<String>.from(json['following'] ?? []),
      birthday: json['birthday'] != null ? (json['birthday'] as Timestamp).toDate() : null
    );
  }


  static Map<String , dynamic> toJson (CurrentUser user) => {
    "id" : user.id,
    "avatarUrl" : user.avatarUrl,
    "fullName" : user.fullName,
    "userName" : user.userName,
    "email" : user.email,
    "followers" : user.followers,
    "following" : user.following,
    "birthday" : user.birthday
  };
}