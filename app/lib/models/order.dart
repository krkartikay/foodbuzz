import '../utils/constants.dart';
import 'package:requests/requests.dart';
import 'dart:convert';
import 'product.dart';

class Order {
  int oid;
  DateTime timestamp;
  int status;
  int totalPrice;

  Order({
    this.oid,
    this.timestamp,
    this.status,
    this.totalPrice
  });

  factory Order.fromJson(Map<String, dynamic> parsedJson) {
    return Order(
      oid: parsedJson['oid'],
      status: parsedJson['status'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(parsedJson['timestamp'] * 1000),
      totalPrice: parsedJson['totalprice'],
    );
  }
}

class Orders {
  final int uid;
  final Map<int, Order> mp = {};
  bool loaded = false;

  Orders(this.uid);
  
  Future<void> loadOrders() {
    return Requests.get(BACKEND + "/orders/$uid").then((resp) {
      Map<String, dynamic> data = jsonDecode(resp);
      for (var oid in data.keys) {
        mp[int.parse(oid)] = Order.fromJson(data[oid]);
      }
      loaded = true;
    });
  }
}

class RecievedOrderDetails {
  int oid;
  DateTime timestamp;
  // TODO: IMPLEMENT LATER
}

class CreatedOrder {
  final int vid;
  Map<int, int> qty = {};
  int totalPrice = 0;
  
  // TODO: time estimate logic
  Duration estTime = Duration(minutes: 5);

  CreatedOrder(this.vid); // pid -> qty map
  
  String toJson(){
    return jsonEncode({
      'vid': vid,
      'order': qty,
    });
  }

  void addProduct(Product p){
    qty[p.pid] ++;
    totalPrice += p.price;
  }
  void removeProduct(Product p){
    qty[p.pid] --;
    totalPrice -= p.price;
  }

  Future<void> placeOrder(){
    return Requests.post(BACKEND+"/placeOrder", json: this.toJson());
  }
}