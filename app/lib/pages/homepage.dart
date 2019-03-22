import 'package:flutter/material.dart';
import '../models/user.dart';


class HomePage extends StatefulWidget {
  final UserModel userModel;
  const HomePage({Key key, this.userModel}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FoodBUZZ"),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.eject), onPressed: () {
            widget.userModel.logout().then((_){
              Navigator.of(context).pushNamed('/login');
            });
          },)
        ],
      ),
      body: Center(
        child: Text("FoodBuzz"),
      ),
    );
  }
}
