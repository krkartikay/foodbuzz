import 'package:flutter/material.dart';
import '../widgets/heading.dart';
import '../models/order.dart';
import '../models/user.dart';

class OrderStatusPage extends StatefulWidget {
  final int oid;
  final UserModel um;
  const OrderStatusPage({Key key, this.oid, this.um}) : super(key: key);
  @override
  _OrderStatusPageState createState() => _OrderStatusPageState();
}

class _OrderStatusPageState extends State<OrderStatusPage> {
  bool done = false;
  Orders allOrders;
  @override
  void initState() {
    allOrders = Orders(widget.um.user.uid);
    allOrders.loadOrders().then((_) {
      setState(() {
        done = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!done) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      Order o = allOrders.mp[widget.oid];
      return OrderSent(
        orderid: o.oid,
        status: (o.status == 1 ? "DONE" : "Submitted"),
        timest: o.timestamp.toLocal().toString(),
        totalamount: o.totalPrice,
      );
    }
  }
}

class OrderSent extends StatelessWidget {
  final int orderid;
  final int totalamount;
  final String timest;
  final String status;

  const OrderSent(
      {Key key, this.orderid, this.totalamount, this.timest, this.status})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // backgroundColor: Colors.white,
          ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(150.0),
                color: Colors.lightGreen,
                border: Border.all(color: Colors.green, width: 5.0),
                boxShadow: [
                  BoxShadow(blurRadius: 20.0, color: Colors.lightGreen)
                ],
              ),
              child: Icon(
                Icons.done,
                color: Colors.white,
                size: 150.0,
              ),
            ),
          ),
          Center(child: Heading1nb("Order Confirmed!")),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PaddedText(
                    "Order Details",
                    size: 25.0,
                  ),
                  Row(
                    children: <Widget>[
                      PaddedText(
                        "Order ID: ",
                        size: 20.0,
                        top: 2.0,
                        bottom: 2.0,
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      PaddedText(
                        orderid.toString(),
                        size: 20.0,
                        bold: true,
                        top: 2.0,
                        bottom: 2.0,
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      PaddedText(
                        "Total Amount: ",
                        size: 20.0,
                        top: 2.0,
                        bottom: 2.0,
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      PaddedText(
                        "\$ " + totalamount.toString(),
                        size: 20.0,
                        bold: true,
                        top: 2.0,
                        bottom: 2.0,
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      PaddedText(
                        "Submitted On: ",
                        size: 20.0,
                        top: 2.0,
                        bottom: 2.0,
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      PaddedText(
                        timest.split(" ")[0].split(".")[0],
                        size: 20.0,
                        bold: true,
                        top: 2.0,
                        bottom: 2.0,
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      PaddedText(
                        "Estimated Time: ",
                        size: 20.0,
                        top: 2.0,
                        bottom: 2.0,
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      PaddedText(
                        "5 minutes",
                        size: 20.0,
                        bold: true,
                        top: 2.0,
                        bottom: 2.0,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
