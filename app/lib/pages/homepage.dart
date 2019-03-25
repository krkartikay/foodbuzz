import 'dart:async';

import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/vendor.dart';
import '../widgets/vendor_card.dart';
import '../widgets/heading.dart';

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
    _reload();
    super.initState();
  }

  void _reload(){
    if(widget.userModel.user == null){
      Future.delayed(Duration(seconds: 1), (){
        widget.userModel.reloadUser().then((_){
          _reload();
          setState(() {});
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FoodBUZZ"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              // logout button
              widget.userModel.logout().then((_) {
                Navigator.of(context).pushNamed('/login');
              });
            },
          ),
          SizedBox(
            width: 10.0,
          )
        ],
      ),
      body: RefreshIndicator(
        child: Center(
          child: (done == false || widget.userModel.user == null)
              ? Text("Loading ...")
              : ListView(
                  children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Card(
                            elevation: 3.0,
                            child: ListTile(
                              title: Text("Remaining Balance: "),
                              trailing: Heading1("\$${widget.userModel.user.balance}"),
                            ),
                          ),
                        ),
                      ] +
                      vendorModel.mp.keys.map((int vid) {
                        return VendorCard(v: vendorModel.mp[vid], um: widget.userModel,);
                      }).toList(),
                ),
        ),
        onRefresh: () {
          setState(() {
            done = false;
          });
          return vendorModel.loadVendors().then((_) {
            setState(() {
              done = true;
            });
          });
        },
      ),
    );
  }
}
