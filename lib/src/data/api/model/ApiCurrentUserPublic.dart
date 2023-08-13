// ignore_for_file: file_names


import 'package:music_app/src/domain/model/CurrentUser.dart';

class ApiCurrentUserPublic {
  
  static Map<String , dynamic> toJson (CurrentUser user) => {
    "id" : user.id,
    "avatarUrl" : user.avatarUrl,
    "fullName" : user.fullName,
    "userName" : user.userName,
    "email" : user.email,
    "followers" : user.followers,
    "following" : user.following,
    "birthday" :  user.birthday
  };

}
