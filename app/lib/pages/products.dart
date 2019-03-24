import 'package:flutter/material.dart';

import '../pages/order_status.dart';
import '../models/vendor.dart';
import '../models/product.dart';
import '../models/order.dart';
import '../widgets/product_card.dart';
import '../widgets/big_card.dart';
import '../widgets/heading.dart';

class ProductPage extends StatefulWidget {
  final Vendor v;
  const ProductPage({Key key, this.v}) : super(key: key);
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  bool done = false;
  Products productsModel;
  CreatedOrder order;

  @override
  void initState() {
    productsModel = Products(widget.v.vid);
    order = CreatedOrder(widget.v.vid);
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
                children: <Widget>[] +
                    productsModel.types.keys.map((String type) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[Heading1(type.toUpperCase())] +
                            productsModel.types[type].map((int pid) {
                              return ProductCard(
                                product: productsModel.mp[pid],
                                onChanged: (Product p, int val) {
                                  setState(() {
                                    order.setQty(p, val);
                                  });
                                },
                              );
                            }).toList(),
                      );
                    }).toList() +
                    <Widget>[
                      PaddedText(""),
                      BigCard(
                        totalOrder: order.totalPrice,
                        onConfirm: () {
                          order.placeOrder().then((int oid) {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return OrderStatusPage(oid: oid);
                                },
                              ),
                            );
                          });
                        },
                      )
                    ],
              ),
      ),
    );
  }
}
