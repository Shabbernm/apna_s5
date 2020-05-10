import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart';
import '../providers/conf_data.dart';

class ShopCategory {
  final String id;
  final String name;
  final String description;
  final String image;
  ShopCategory({
    @required this.id,
    @required this.name,
    @required this.description,
    @required this.image,
  });
}

class ShopCategories {
  static List<ShopCategory> _items = [];

  static List<ShopCategory> get items {
    return [..._items];
  }

  static Future<void> fetchShopCategories() async {
    var url = basic_URL + 'shopCategory/';
    final response = await http.get(url, headers: headers);
    final responseData = json.decode(response.body);
    _items.clear();
    responseData.forEach((item) {
      _items.add(classMapToObj(item));
    });
  }

  static ShopCategory classMapToObj(Map<String, dynamic> localMap) {
    return ShopCategory(
        id: localMap['id'].toString(),
        name: localMap['Name'],
        description: localMap['Description'],
        image: localMap['image'],
      );
  }
}
