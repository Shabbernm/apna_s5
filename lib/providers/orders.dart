import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import './conf_data.dart';
import '../models/order_status.dart';

class OrderedProduct {
  final String productId;
  final String name;
  final int quantity;
  final double price;

  OrderedProduct({
    @required this.productId,
    @required this.name,
    @required this.quantity,
    @required this.price,
  });
}

class Order {
  final String id;
  final String user;
  final double total;
  final String slug;
  String orderStatus;
  final String note;

  Order({
    @required this.id,
    @required this.user,
    @required this.total,
    @required this.slug,
    @required this.orderStatus,
    @required this.note,
  });
}

class Orders with ChangeNotifier {
  static List<Order> _items = [];

  List<Order> get items {
    return [..._items];
  }

  Future<void> fetchOrders() async {
    var url = basic_URL + 'order/?getShopOrders=0';

    final response = await http.get(url, headers: headers);
    final responseData = json.decode(response.body);

    _items.clear();
    responseData.forEach((order) {
      _items.add(classMapToObj(order));
    });
  }

  Future<void> fetchDataFromServer() async {
    print('calling fetchOrders');
    await fetchOrders();
    // await fetchOrderShopProducts();
    notifyListeners();
    Timer(Duration(seconds: 10), fetchDataFromServer);
  }

  Future<void> cofirmOrder(String orderId) async {
    var url = basic_URL + 'order/$orderId/';
    var body = json.encode({
      'Order_Status': OrderStatuses.items
          .firstWhere((orderStatus) => orderStatus.name == 'Confirmed by Shop')
          .id,
    });
    var response = await http.patch(url, headers: headers, body: body);
    final responseData = json.decode(response.body);
    print('responseData in cofirmOrder');
    print(responseData);
  }

  Future<void> rejectOrder(String orderId, String rejectReason) async {
    print('rejectReason: $rejectReason');
    var url = basic_URL + 'order/$orderId/';
    var body = json.encode({
      'Order_Status': OrderStatuses.items
          .firstWhere((orderStatus) => orderStatus.name == 'Rejected')
          .id,
      'Note': rejectReason,
    });
    var response = await http.patch(url, headers: headers, body: body);
    final responseData = json.decode(response.body);
    print('responseData in rejectOrder');
    print(responseData);
  }
  static void changeStatus(String orderId, String status){
    _items.firstWhere((order)=>order.id==orderId).orderStatus=status;
  }

  void addProduct() {
    // _items.add(value)
    notifyListeners();
  }

  void addOrder() {
    // _items.add(value)
    notifyListeners();
  }

  Future<void> fetchOrderShopProducts() async {
    print('This is function not used any more');
    // var url = basic_URL + 'orderShopProduct/?todayOrders=5';

    // final response = await http.get(url, headers: headers);
    // final responseData = json.decode(response.body);

    // _items.clear();
    // responseData.forEach((orderShopProduct) {
    //   OrderShopProducts.addOrderShopProductAndDependents(orderShopProduct);
    // });
    // print('Order list is');
    // print(_items);
  }

  static void addOrderToList(Order order) {
    bool found = false;
    _items.forEach((item) {
      if (item.id == order.id) {
        found = true;
      }
    });
    if (found == false) {
      _items.add(order);
    }
  }

  static Order classMapToObj(Map<String, dynamic> localMap) {
    // OrderStatuses.addOrderStatusToLocalList(OrderStatuses.classMapToObj(localMap['Order_Status']));
    return Order(
      id: localMap['id'].toString(),
      user: localMap['user'].toString(),
      total: double.parse(localMap['Total']),
      slug: localMap['slug'],
      orderStatus: localMap['Order_Status']['Name'].toString(),
      note: localMap['Note'],
    );
  }
}
