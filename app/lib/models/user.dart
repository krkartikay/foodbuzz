import '../utils/constants.dart';
import 'package:requests/requests.dart';
import 'dart:convert';

class User {
  final int uid;
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
  bool loggedIn = false;
  User user;

  Future<void> reloadUser() {
    return Requests.get(BACKEND + "/userinfo").then((resp) {
      loggedIn = jsonDecode(resp)['loggedin'];
      if(loggedIn){
        user = User.fromJson(jsonDecode(resp)['user_data']);
      }
    });
  }

  Future<void> login(String email, String pass){
    return Requests.post(BACKEND + "/login", body: {
      'email': email,
      'password': pass,
    }).then((resp) {
      if (jsonDecode(resp)['success'] == true){
        print("login successful");
      } else {
        throw(jsonDecode(resp)['error']);
      }
    });
  }

  Future<void> logout(){
    return Requests.get(
      BACKEND + "/logout",
    );
  }

  Future<void> register(String email, String pass){
    return Requests.post(BACKEND + "/register", body: {
      'email': email,
      'password': pass,
    }).then((resp) {
      if (jsonDecode(resp)['success'] == true){
        print("register successful");
      }
    }).catchError((error){
      print("error in register, $error");
    });
  }
}
