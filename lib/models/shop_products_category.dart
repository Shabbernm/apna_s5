import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart';

import '../providers/conf_data.dart';
import './product_category.dart';
import '../models/shops.dart';

class ShopProductsCategory {
  final String id;
  final String shop;
  final String productCategory;
  final String slug;

  ShopProductsCategory({
    @required this.id,
    @required this.shop,
    @required this.productCategory,
    @required this.slug,
  });
}

class ShopProductsCategories {
  static List<ShopProductsCategory> _items = [];

  static List<ShopProductsCategory> get items {
    return [..._items];
  }

  static Future<void> fetchShopProductsCategories() async {
    // print('Shops.items[0].shopId in fetchShopProductsCategories is: ${Shops.items[0].shopId}');
    var url = basic_URL +
        'shopProductCategory/?shopId=${Shops.items.length > 0 ? Shops.items[0].shopId : 0}';
    final response = await http.get(url, headers: headers);
    final responseData = json.decode(response.body);
    // _items.clear();
    // print(responseData);
    responseData.forEach((item) {
      _items.add(classMapToObj(item));
      // print(ProductCategories.items.length);
      ProductCategories.items
          .firstWhere(
              (item2) => item2.id == item['Product_Category']['id'].toString())
          .active = true;
    });
  }

  static Future<void> deleteShopProductsCategory(String id) async {
    var url = basic_URL + 'shopProductCategory/$id/';
    final response = await http.delete(url, headers: headers);
    // print(response);
    final responseData = json.decode(response.body);
    print(responseData);
  }

  static Future<void> insertShopProductsCategory(
      String shopId, String productCategoriesId) async {
    var url = basic_URL + 'shopProductCategory/';
    var body = json.encode({
      'Shop': shopId,
      'Product_Category': productCategoriesId,
    });
    final response = await http.post(url, headers: headers, body: body);
    // print(response);
    final responseData = json.decode(response.body);
    print(responseData);
    // add locally
    _items.add(classMapToSingleObj(responseData));
    // print(ProductCategories.items.length);
    ProductCategories.items
        .firstWhere((item2) =>
            item2.id == responseData['Product_Category'].toString())
        .active = true;
  }

  static ShopProductsCategory classMapToObj(Map<String, dynamic> localMap) {
    return ShopProductsCategory(
      id: localMap['id'].toString(),
      shop: localMap['Shop']['id'].toString(),
      productCategory: localMap['Product_Category']['id'].toString(),
      slug: localMap['slug'],
    );
  }

  static ShopProductsCategory classMapToSingleObj(Map<String, dynamic> localMap) {
    return ShopProductsCategory(
      id: localMap['id'].toString(),
      shop: localMap['Shop'].toString(),
      productCategory: localMap['Product_Category'].toString(),
      slug: localMap['slug'],
    );
  }
}
