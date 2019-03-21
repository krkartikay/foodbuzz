import '../utils/constants.dart';
import 'package:requests/requests.dart';
import 'dart:convert';

class User {
  final String uid;
  final String email;
  final int balance;

  User({this.uid, this.email, this.balance});

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    // Map<String, dynamic> parsedJson = jsonDecode(json);
    return User(
      uid: parsedJson['uid'],
      email: parsedJson['email'],
      balance: parsedJson['balance'],
    );
  }
}

class UserModel {
  User user;

  Future<void> reloadUser() {
    return Requests.get(BACKEND + "/userinfo").then((resp) {
      user = User.fromJson(jsonDecode(resp));
    });
  }
}
