import 'package:flutter/material.dart';
import 'pages/homepage.dart';
import 'pages/loginpage.dart';
import 'models/user.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var userModel = UserModel();
    return MaterialApp(
      title: 'FoodBUZZ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (context) => HomePage(
          userModel: userModel,
        ),
        '/login': (context) => LoginPage(
          userModel: userModel,
        ),
      },
      initialRoute: '/login',
    );
  }
}