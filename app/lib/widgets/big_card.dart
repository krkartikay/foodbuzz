import 'package:flutter/material.dart';
import '../widgets/heading.dart';

class BigCard extends StatelessWidget {

  final int totalOrder;
  final Function onConfirm;

  const BigCard({Key key, this.totalOrder, this.onConfirm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Heading1("Total Order:"),
          Heading0nb("\$$totalOrder"),
          Row(
            children: <Widget>[
              Expanded(
                child: Container(),
              ),
              FlatButton(
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              SizedBox(
                width: 10.0,
              ),
              RaisedButton(
                child: Text(
                  "Confirm",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: onConfirm,
                color: Colors.blue,
                elevation: 3.0,
              ),
              SizedBox(
                width: 10.0,
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          )
        ],
      ),
    );
  }
}
