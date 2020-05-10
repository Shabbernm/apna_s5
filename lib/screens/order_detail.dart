import 'package:apna_s5/screens/orders.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/order_shop.dart';
import '../models/order_shop_product.dart';
import '../models/product.dart';
import '../models/shop_product.dart';
import '../providers/orders.dart';
import '../screens/splash.dart';

class OrderDetailScreen extends StatefulWidget {
  static const routeName = '/OrderDetailScreen';

  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  String rejectReason = '';

  Future<bool> _showNote(BuildContext context, String message) {
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Note is!'),
            content: Text(message),
          ),
        ) ??
        false;
  }

  Future<bool> _rejectReasonAlert(BuildContext context, String orderId) {
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Note is!'),
            content: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Reason'),
                      keyboardType: TextInputType.text,
                      onSaved: (value) {
                        rejectReason = value;
                      },
                    ),
                  ],
                )),
            actions: <Widget>[
              RaisedButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text("Cancel"),
              ),
              SizedBox(height: 16),
              RaisedButton(
                onPressed: () => _rejectOrder(context, orderId),
                child: Text("Reject Order"),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _confirmOrder(BuildContext context, String orderId) async {
    await Provider.of<Orders>(context, listen: false).cofirmOrder(orderId);
    Orders.changeStatus(orderId, 'Confirmed by Shop');
    Navigator.of(context).pop();
  }

  void _rejectOrder(BuildContext context, String orderId) async {
    // setState(() {
    //   _isLoading = true;
    // });
    print('before rejectReason: $rejectReason');
    _formKey.currentState.save();
    print('after rejectReason: $rejectReason');
    await Provider.of<Orders>(context, listen: false)
        .rejectOrder(orderId, rejectReason);
    Orders.changeStatus(orderId, 'Rejected');
    Navigator.of(context).pop(true);
    Navigator.of(context).pop();
    // Navigator.of(context).popAndPushNamed(OrderScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    String orderId = ModalRoute.of(context).settings.arguments as String;

    Order order = Provider.of<Orders>(context, listen: false)
        .items
        .firstWhere((order) => order.id == orderId);
    // Provider.of<OrderShops>(context).i
    return FutureBuilder(
      future: OrderShopProducts.fetchOrderShopProducts(orderId),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(title: Text('Order Detail')),
            body: Column(
              children: <Widget>[
                Expanded(
                  child: ListView(
                    children: OrderShopProducts.items.map((orderShopProduct) {
                      ShopProduct shopProduct = ShopProducts.items.firstWhere(
                          (shopProduct) =>
                              shopProduct.id == orderShopProduct.shopProduct);
                      Product product = Products.items
                          .firstWhere((prod) => prod.id == shopProduct.product);
                      String subtitleText = '';
                      if (orderShopProduct.quantity == 0) {
                        // weight
                        subtitleText =
                            '${orderShopProduct.weight} Kg  -  ${orderShopProduct.weight * shopProduct.price} Pkr  -  ${shopProduct.price}';
                      } else {
                        // quantity
                        subtitleText =
                            '${orderShopProduct.quantity}  -  ${orderShopProduct.quantity * shopProduct.price} Pkr  -  ${shopProduct.price}';
                      }
                      return ListTile(
                        leading:
                            Image.network(product.image, fit: BoxFit.cover),
                        title: Text(product.name),
                        subtitle: Text(subtitleText),
                        trailing: orderShopProduct.note == ''
                            ? null
                            : RaisedButton(
                                child: Text('Note'),
                                onPressed: () =>
                                    _showNote(context, orderShopProduct.note),
                              ),
                      );
                    }).toList(),
                  ),
                ),
                Text('Customer name and customer address'),
                Text('Order Total: ${OrderShops.items[0].itemsTotal}'),
                Row(
                  children: <Widget>[
                    Text('Current Status: ${order.orderStatus}'),
                    if (order.orderStatus == 'Pending')
                      Row(children: <Widget>[
                        RaisedButton(
                          child: Text('Confirm'),
                          onPressed: () => _confirmOrder(context, orderId),
                        ),
                        RaisedButton(
                          child: Text('Reject'),
                          onPressed: () => _rejectReasonAlert(context, orderId),
                        ),
                      ]),
                  ],
                ),
              ],
            ),
          );
        } else {
          return SplashScreen('Fetching Order Details');
        }
      },
    );
  }
}
