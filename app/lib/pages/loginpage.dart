import 'package:flutter/material.dart';
import '../models/user.dart';

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
      logout: doLogout,
    );
  }

  Future<void> doLogin(String email, String pass) {
    return widget.userModel.login(email, pass);
  }

  Future<void> doLogout() {
    return widget.userModel.logout();
  }
}

class ActualLoginPage extends StatefulWidget {
  final Function login;
  final Function logout;

  const ActualLoginPage({Key key, this.login, this.logout}) : super(key: key);

  @override
  _ActualLoginPageState createState() => _ActualLoginPageState();
}

class _ActualLoginPageState extends State<ActualLoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(
          child: Text("DO THE LOGIN"),
          onPressed: () {
            widget.login("kk@g.com", "hunter2").then((_) {
              Navigator.pop(context);
            }).catchError((_){
              print("error logging in!");
            });
          },
        ),
      ),
    );
  }
}
