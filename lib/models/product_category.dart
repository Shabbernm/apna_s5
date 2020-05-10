import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart';
import '../providers/conf_data.dart';
import '../models/shops.dart';

class ProductCategory {
  final String id;
  final String name;
  final String description;
  final String shopCategory;
  final String image;
  final String slug;
  bool active;

  ProductCategory({
    @required this.id,
    @required this.name,
    @required this.description,
    @required this.shopCategory,
    @required this.image,
    @required this.slug,
    this.active = false,
  });
}

class ProductCategories {
  static List<ProductCategory> _items = [];

  static List<ProductCategory> get items {
    return [..._items];
  }

  static Future<void> fetchProductsCategories() async {
    // print('Shop Category id is: '+ Shops.items[0].shopCategory);
    var url = basic_URL +
        'productCategory/?shopCategoryId=${Shops.items.length > 0 ? Shops.items[0].shopCategory : 0}';
    final response = await http.get(url, headers: headers);
    final responseData = json.decode(response.body);
    // _items.clear();
    // print(responseData.length);
    responseData.forEach((item) {
      _items.add(classMapToObj(item));
    });
  }

  static List<String> getProductsCategoriesIdList() {
    List<String> localList = [];
    items.forEach((item) {
      if (item.active) {
        localList.add(item.id);
      }
    });
    return localList;
  }

  static ProductCategory classMapToObj(Map<String, dynamic> localMap) {
    return ProductCategory(
        id: localMap['id'].toString(),
        name: localMap['Name'],
        description: localMap['Description'],
        shopCategory: localMap['Shop_Category'].toString(),
        image: localMap['image'],
        slug: localMap['slug'],
      );
  }
}
