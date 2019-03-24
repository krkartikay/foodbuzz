import 'package:flutter/material.dart';
import '../models/product.dart';
import 'steppertouch.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final Function onChanged;
  const ProductCard({Key key, this.product, this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Card(
        child: ListTile(
          title: Text(
            product.name.toUpperCase(),
            style: TextStyle(fontSize: 18.0),
          ),
          subtitle: Text(
            "Price: \$${product.price}.   ${product.qtyLeft} left in stock",
          ),
          trailing: StepperTouch(
            color1: Colors.white,
            color2: Colors.blue,
            onChanged: (int value) {
              onChanged(product, value);
            },
          ),
        ),
      ),
    );
  }
}