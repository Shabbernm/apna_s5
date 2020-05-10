import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../providers/conf_data.dart';

class ProductUnitType {
  final String id;
  final String name;
  final String description;

  ProductUnitType({
    @required this.id,
    @required this.name,
    @required this.description,
  });
}

class ProductUnitTypes {
  static List<ProductUnitType> _items = [];

  static List<ProductUnitType> get items {
    return [..._items];
  }

  static Future<void> fetchProductUnitTypes() async {
    var url = basic_URL + 'productUnitType/';
    final response = await http.get(url, headers: headers);
    final responseData = json.decode(response.body);
    _items.clear();
    responseData.forEach((item) {
      _items.add(ProductUnitType(
        id: item['id'].toString(),
        name: item['Name'],
        description: item['Description'],
      ));
    });
  }

   static void addProductUnitType(ProductUnitType productUnitType) {
    bool found = false;
    _items.forEach((item) {
      if (item.id == productUnitType.id) {
        found = true;
      }
    });
    if(found == false){
      _items.add(productUnitType);
    }
  }

   static ProductUnitType classMapToObj(Map<String, dynamic> localMap) {
    return ProductUnitType(
        id: localMap['id'].toString(),
        name: localMap['Name'],
        description: localMap['Description'],
      );
  }
}
