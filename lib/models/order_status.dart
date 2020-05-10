import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../providers/conf_data.dart';

class OrderStatus {
  final String id;
  final String name;
  final String description;

  OrderStatus({
    @required this.id,
    @required this.name,
    @required this.description,
  });
}

class OrderStatuses {
  static List<OrderStatus> _items = [];

  static List<OrderStatus> get items {
    return [..._items];
  }

  static Future<void> fetchOrderStatuses() async {
    var url = basic_URL + 'orderStatus/';
    final response = await http.get(url, headers: headers);
    final responseData = json.decode(response.body);
    _items.clear();
    responseData.forEach((item) {
      addOrderStatusToLocalList(classMapToObj(item));
    });
  }

  static void addOrderStatusToLocalList(OrderStatus orderStatus) {
    bool prodFound = false;
    _items.forEach((item) {
      if (item.id == orderStatus.id) {
        prodFound = true;
      }
    });
    if (prodFound == false) {
      _items.add(orderStatus);
    }
  }

  static OrderStatus classMapToObj(Map<String, dynamic> localMap) {
    return OrderStatus(
      id: localMap['id'].toString(),
      name: localMap['Name'],
      description: localMap['Description'],
    );
  }
}
