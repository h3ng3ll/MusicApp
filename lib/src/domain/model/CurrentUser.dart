// ignore_for_file: file_names
import 'package:music_app/src/domain/repository/User.dart';

class CurrentUser extends User {



  String userName;
  final String fullName;
  final String email;
  //
  DateTime? birthday;

   late  List<String> followers;
   late  List<String> following;

  CurrentUser({
    List<String>? followers,
    List<String>? following,
    String? avatarUrl,
    this.birthday,
    required this.email,
    required String id ,
    required this.userName,
    required this.fullName,
  }) : super(id: id , avatarUrl: avatarUrl) {
    this.followers = (followers ?? []);
    this.following = (following ?? []);
  }
}
