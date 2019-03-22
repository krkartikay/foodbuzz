import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/vendor.dart';
import '../widgets/vendor_card.dart';

class HomePage extends StatefulWidget {
  final UserModel userModel;
  const HomePage({Key key, this.userModel}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool done = false;
  var vendorModel = Vendors();

  @override
  void initState() {
    vendorModel.loadVendors().then((_) {
      setState(() {
        done = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FoodBUZZ"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.eject),
            onPressed: () {
              // logout button
              widget.userModel.logout().then((_) {
                Navigator.of(context).pushNamed('/login');
              });
            },
          )
        ],
      ),
      body: Center(
        child: (done == false)
            ? Text("Loading ...")
            : ListView(
                children: vendorModel.mp.keys.map((int vid) {
                  return VendorCard(v: vendorModel.mp[vid]);
                }).toList(),
              ),
      ),
    );
  }
}
