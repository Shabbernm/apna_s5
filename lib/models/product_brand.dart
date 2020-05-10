import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../providers/conf_data.dart';

class ProductBrand {
  final String id;
  final String name;
  final String description;
  final String productCategory;

  ProductBrand({
    @required this.id,
    @required this.name,
    @required this.description,
    @required this.productCategory,
  });
}

class ProductBrands {
  static List<ProductBrand> _items = [];

  static List<ProductBrand> get items {
    return [..._items];
  }

  static Future<void> fetchProductBrands() async {
    var url = basic_URL + 'productBrand/';
    final response = await http.get(url, headers: headers);
    final responseData = json.decode(response.body);
    _items.clear();
    responseData.forEach((item) {
      _items.add(classMapToObj(item));
    });
  }

   static void addProductBrand(ProductBrand productBrand) {
    bool found = false;
    _items.forEach((item) {
      if (item.id == productBrand.id) {
        found = true;
      }
    });
    if(found == false){
      _items.add(productBrand);
    }
  }

  static ProductBrand classMapToObj(Map<String, dynamic> localMap) {
    return ProductBrand(
        id: localMap['id'].toString(),
        name: localMap['Name'],
        description: localMap['Description'],
        productCategory: localMap['Product_Category']['id'].toString(),
      );
  }
}
