import 'package:flutter/material.dart';
import '../models/user.dart';
import './actual_login_page.dart';

class LoginPage extends StatefulWidget {
  final UserModel userModel;
  const LoginPage({Key key, this.userModel}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool done = false;

  @override
  void initState() {
    widget.userModel.reloadUser().then((_) {
      if (widget.userModel.loggedIn) {
        print("Popping!");
        Navigator.of(context).pop();
      } else {
        setState(() {
          done = true;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!done) {
      return Scaffold(body: Center(child: CircularProgressIndicator(),),);
    }
    return ActualLoginPage(
      login: doLogin,
      register: doRegister,
    );
  }

  Future<void> doLogin(String email, String pass) {
    return widget.userModel.login(email, pass);
  }

  Future<void> doRegister(String email, String pass) {
    return widget.userModel.register(email, pass);
  }
}
