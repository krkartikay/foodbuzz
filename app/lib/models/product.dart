import '../utils/constants.dart';
import 'package:requests/requests.dart';
import 'dart:convert';

class Product {
  int pid;
  int vid;
  String name;
  String type;
  String description;
  String photoURL;
  int price;
  Duration estTime;
  int qtyLeft;

  Product({
    this.pid,
    this.vid,
    this.name,
    this.type,
    this.description,
    this.photoURL,
    this.price,
    this.estTime,
    this.qtyLeft,
  });

  factory Product.fromJson(Map<String, dynamic> parsedJson) {
    // Map<String, dynamic> parsedJson = jsonDecode(json);
    return Product(
      pid: parsedJson['pid'],
      vid: parsedJson['vid'],
      name: parsedJson['name'],
      type: parsedJson['type'],
      description: parsedJson['description'],
      photoURL: parsedJson['photoURL'],
      price: parsedJson['price'],
      estTime: Duration(minutes: parsedJson['est_time']),
      qtyLeft: parsedJson['qty_left'],
    );
  }
}

class Products {
  final int vid;
  final Map<int, Product> mp = {};
  final Map<String, List<int>> types = {};
  bool loaded = false;

  Products(this.vid);
  
  Future<void> loadProducts() {
    return Requests.get(BACKEND + "/products/$vid").then((resp) {
      Map<String, dynamic> data = jsonDecode(resp);
      for (var pid in data.keys) {
        int p = int.parse(pid);
        mp[p] = Product.fromJson(data[pid]);
        if(types[mp[p].type] == null){
          types[mp[p].type] = [];
        }
        types[mp[p].type].add(p);
      }
      loaded = true;
    });
  }
}
