import 'package:apna_s5/screens/order_detail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = '/OrderScreen';
  // var _isInit = true;

  // @override
  // void didChangeDependencies() {
  //   // TODO: implement didChangeDependencies
  //   if (_isInit) {
  //     Provider.of<Orders>(context).fetchDataFromServer();
  //     _isInit = false;
  //   }
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    final loadedOrders = Provider.of<Orders>(context).items;
    return Scaffold(
      appBar: AppBar(title: Text('Orders')),
      body: loadedOrders.length > 0
          ? ListView(
              children: loadedOrders.map((order) {
                return Card(
                  child: ListTile(
                    title: Text(order.slug),
                    trailing: Text(order.orderStatus),
                    onTap: () => Navigator.of(context).pushNamed(
                        OrderDetailScreen.routeName,
                        arguments: order.id),
                  ),
                );
              }).toList(),
            )
          : Center(
              child: Text('Kindly wait for your first order!'),
            ),
    );
  }
}
