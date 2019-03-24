import 'package:flutter/material.dart';
import '../pages/products.dart';
import '../models/vendor.dart';
import '../widgets/heading.dart';

class VendorCard extends StatelessWidget {
  final Vendor v;

  const VendorCard({Key key, this.v}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      child: InkWell(
        child: Card(
          elevation: 3.0,
          child: Container(
            // height: 160.0,
            child: Row(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Heading1x(v.name),
                    PaddedText(
                      "Contact: ${v.contactNo}",
                      top: 20.0,
                      bottom: 5.0,
                    ),
                    PaddedText(
                      v.open ? "Open now!" : "CLOSED",
                      top: 5.0,
                      bottom: 30.0,
                      textcolor: v.open ? Colors.blue : Colors.red,
                    ),
                  ],
                ),
                Expanded(
                  child: Container(),
                ),
                ClipRRect(
                  borderRadius: new BorderRadius.circular(50.0),
                  child: Image.asset(
                    v.photoURL,
                    height: 100.0,
                    width: 100.0,
                  ),
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          if (!v.open) {
            Scaffold.of(context).showSnackBar(new SnackBar(
              content: new Text("This vendor is closed right now."),
            ));
            return;
          }
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ProductPage(
                    v: v,
                  )));
        },
      ),
      padding: EdgeInsets.all(20.0),
    );
  }
}
