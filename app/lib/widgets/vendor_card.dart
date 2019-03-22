import 'package:flutter/material.dart';
import '../pages/products.dart';
import '../models/vendor.dart';

class VendorCard extends StatelessWidget {
  final Vendor v;

  const VendorCard({Key key, this.v}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Card(
        child: ListTile(
          title: Text(v.name),
        ),
      ),
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProductPage(v: v,)));
      },
    );
  }
}
