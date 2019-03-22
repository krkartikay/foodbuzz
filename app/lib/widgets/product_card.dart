import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductCard extends StatelessWidget {
  final Product p;

  const ProductCard({Key key, this.p}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Card(
        child: ListTile(
          title: Text(p.name),
        ),
      ),
    );
  }
}
