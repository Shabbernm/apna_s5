import 'dart:convert';
import 'package:apna_s5/models/product_brand.dart';
import 'package:apna_s5/models/shops.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../providers/conf_data.dart';
import './product.dart';
import '../models/product_subcategory.dart';
import '../models/product_unit_type.dart';

class ShopProduct {
  final String id;
  final String product;
  final String shopProductCategory;
  double price;
  final String slug;

  ShopProduct({
    @required this.id,
    @required this.product,
    @required this.shopProductCategory,
    @required this.price,
    @required this.slug,
  });
}

class ShopProducts {
  static List<ShopProduct> _items = [];
  static List<ShopProduct> _itemsList2 = [];

  static List<ShopProduct> get items {
    return [..._items];
  }

  static List<ShopProduct> get itemsList2 {
    return [..._itemsList2];
  }

  static Future<List<ShopProduct>> fetchShopProducts(
      String shopProductsCategoryId) async {
    // print('im in fetch fetchShopProducts');
    // print('shopProductsCategoryId: $shopProductsCategoryId');
    var url = basic_URL +
        'shopProduct/?shopProductsCategoryId=$shopProductsCategoryId';
    final response = await http.get(url, headers: headers);
    final responseData = json.decode(response.body);
    // _items.clear();
    // Products.clearLocalList();
    // ProductSubcategories.clearLocalList();
    // print(responseData);
    // print('before function');
    responseData.forEach((item) {
      addShopProductAndDependents(item);
    });
    // print('after function');
    // print(items);

    return items;
  }

  static List<ShopProduct> getShopProductsBySubcategory(String subcategoryId) {
    List<ShopProduct> localList = [];
    ProductSubcategories.items.forEach(
        (productSubcategory) => productSubcategory.id == subcategoryId);
    items.forEach((shopProduct) {
      if (Products.items
              .firstWhere((product) => product.id == shopProduct.product)
              .productSubcategory ==
          subcategoryId) {
        localList.add(shopProduct);
      }
    });
    return localList;
  }

  static void addShopProductList2(ShopProduct shopProduct) {
    bool founded = false;
    _itemsList2.forEach((item) {
      if (item.id == shopProduct.id) {
        // print('item.id: ${item.id}');
        // print('shopProduct.id: ${shopProduct.id}');
        founded = true;
      }
    });
    if (founded == false) {
      _itemsList2.add(shopProduct);
    }
  }

  static void addShopProductAndDependents(Map<String, dynamic> localMap) {
    // print('in function addShopProductAndDependents');
    _items.add(classMapToObj(localMap));

    addShopProductList2(classMapToObj(localMap));

    Products.addProductToLocalList(Products.classMapToObj(localMap['Product']));

    // print('Products.items.length: ${Products.items.length}');
    Products.items
        .firstWhere(
            (product) => product.id == localMap['Product']['id'].toString())
        .available = true;

    ProductSubcategories.addProductSubcategory(
        ProductSubcategories.classMapToObj(
            localMap['Product']['Product_Subcategory']));

    ProductUnitTypes.addProductUnitType(ProductUnitTypes.classMapToObj(
        localMap['Product']['Product_Unit_Type']));
  }

  static Future<ShopProduct> updateShopProduct(
      ShopProduct shopProdObj, double price) async {
    var url = basic_URL +
        'shopProduct/${shopProdObj.id}/?shopId=${Shops.items.length > 0 ? Shops.items[0].shopId : 0}';
    var body = json.encode({
      'id': shopProdObj.id,
      'Product': shopProdObj.product,
      'Shop_Product_Category': shopProdObj.shopProductCategory,
      'Price': price,
      'slug': shopProdObj.slug,
    });
    var response = await http.put(url, headers: headers, body: body);
    var responseData = json.decode(response.body);
    // print(responseData);
    _items
        .firstWhere((item) => item.id == responseData['id'].toString())
        .price = double.parse(responseData['Price']);

    return classInsertableMapToObj(responseData);
  }

  static Future<void> insertShopProduct(
      Product product, String shopProductCategoryId, double price) async {
    var url = basic_URL + 'shopProduct/';
    var body = json.encode({
      'Product': product.id,
      'Shop_Product_Category': shopProductCategoryId,
      'Price': price,
    });
    var response = await http.post(url, headers: headers, body: body);
    var responseData = json.decode(response.body);
    _items.add(classInsertableMapToObj(responseData));
    print('ProductBrands.items.length: ${ProductBrands.items.length}');
    // print(responseData);
  }

  static Future<void> deleteShopProduct(String id) async {
    var url = basic_URL + 'shopProduct/$id/';
    var response = await http.delete(url, headers: headers);
    var responseData = json.decode(response.body);
    // print(responseData);
  }

  static ShopProduct classMapToObj(Map<String, dynamic> localMap) {
    // print(localMap);
    return ShopProduct(
      id: localMap['id'].toString(),
      product: localMap['Product']['id'].toString(),
      shopProductCategory: localMap['Shop_Product_Category']['id'].toString(),
      price: double.parse(localMap['Price']),
      slug: localMap['slug'],
    );
  }

  static ShopProduct classInsertableMapToObj(Map<String, dynamic> localMap) {
    // print(localMap);
    return ShopProduct(
      id: localMap['id'].toString(),
      product: localMap['Product'].toString(),
      shopProductCategory: localMap['Shop_Product_Category'].toString(),
      price: double.parse(localMap['Price']),
      slug: localMap['slug'],
    );
  }
}
