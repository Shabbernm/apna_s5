import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../providers/conf_data.dart';

class ShopStatus {
  final String id;
  final String name;
  final String description;
  ShopStatus({
    @required this.id,
    @required this.name,
    @required this.description,
  });
}

class ShopStatuses {
  static List<ShopStatus> _items = [];

  static List<ShopStatus> get items {
    return [..._items];
  }

  static Future<void> fetchShopStatuses() async {
    var url = basic_URL + 'shopStatus/';
    final response = await http.get(url, headers: headers);
    final responseData = json.decode(response.body);
    _items.clear();
    responseData.forEach((item) {
      _items.add(classMapToObj(item));
    });
  }

  static ShopStatus classMapToObj(Map<String, dynamic> localMap) {
    return ShopStatus(
        id: localMap['id'].toString(),
        name: localMap['Name'],
        description: localMap['Description'],
      );
  }
}
