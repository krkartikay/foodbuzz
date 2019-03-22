import 'package:flutter/material.dart';

import '../models/vendor.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';

class ProductPage extends StatefulWidget {
  final Vendor v;
  const ProductPage({Key key, this.v}) : super(key: key);
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  bool done = false;
  Products productsModel;

  @override
  void initState() {
    productsModel = Products(widget.v.vid);
    productsModel.loadProducts().then((_) {
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
        title: Text(widget.v.name),
      ),
      body: Center(
        child: (done == false)
            ? Text("Loading ...")
            : ListView(
                children: productsModel.mp.keys.map((int pid) {
                  return ProductCard(p: productsModel.mp[pid]);
                }).toList(),
              ),
      ),
    );
  }
}
