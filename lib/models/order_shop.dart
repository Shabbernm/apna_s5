import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import '../models/shops.dart';
import '../providers/conf_data.dart';
import '../providers/orders.dart';

class OrderShop {
  final String id;
  final String order;
  final String shop;
  final double itemsTotal;
  final int deliveryCharges;
  final String note;
  final String slug;

  OrderShop({
    @required this.id,
    @required this.order,
    @required this.shop,
    @required this.itemsTotal,
    @required this.deliveryCharges,
    @required this.note,
    @required this.slug,
  });
}

class OrderShops {
  static List<OrderShop> _items = [];

  static List<OrderShop> get items {
    return [..._items];
  }

  static Future<void> fetchOrderShops() async {
    var url = basic_URL + 'orderShop/';
    final response = await http.get(url, headers: headers);
    final responseData = json.decode(response.body);
    _items.clear();
    responseData.forEach((item) {
      addOrderShopAndDependents(item);
    });
  }

  void updateLocalList(List<OrderShop> list) {
    _items = list;
  }

  List<OrderShop> getOrderShopsByOrder(String orderId) {
    List<OrderShop> localList = [];
    _items.forEach((item) {
      if (item.order == orderId) {
        localList.add(item);
      }
    });
    return localList;
  }

  static void addOrderShopToList(OrderShop orderShop) {
    bool found = false;
    _items.forEach((shop) {
      if (shop.id == orderShop.id) {
        found = true;
      }
    });
    if (found == false) {
      _items.add(orderShop);
    }
  }

  static OrderShop classMapToObj(Map<String, dynamic> localMap) {
    return OrderShop(
      id: localMap['id'].toString(),
      order: localMap['Order']['id'].toString(),
      shop: localMap['Shop']['id'].toString(),
      itemsTotal: double.parse(localMap['Items_Total']),
      deliveryCharges: localMap['DeliveryCharges'],
      note: localMap['Note'],
      slug: localMap['slug'],
    );
  }

  static void addOrderShopAndDependents(Map<String, dynamic> localMap) {
    addOrderShopToList(classMapToObj(localMap));
    // _items.add(classMapToObj(localMap));

    // add order
    Orders.addOrderToList(Orders.classMapToObj(localMap['Order']));

    // add shop
    Shops.addShopList2(Shops.classMapToObj(localMap['Shop']));
  }
}
