import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import './shops.dart';
import '../providers/conf_data.dart';
import '../models/shop_products_category.dart';

class ProductSubcategory {
  final String id;
  final String name;
  final String description;
  final String productCategory;

  ProductSubcategory({
    @required this.id,
    @required this.name,
    @required this.description,
    @required this.productCategory,
  });
}

class ProductSubcategories{
   static List<ProductSubcategory> _items = [];
   static List<ProductSubcategory> _itemsList2 = [];

   static List<ProductSubcategory> get items {
    return [..._items];
  }

   static List<ProductSubcategory> get itemsList2 {
    return [..._itemsList2];
  }

   static Future<void> fetchProductSubcategories() async {
    //  print('Shops.items[0].shopCategory: ${Shops.items[0].shopCategory}');
    var url = basic_URL +
        'productSubcategory/?shopCategoryId=${Shops.items.length > 0 ? Shops.items[0].shopCategory : 0}';
    final response = await http.get(url, headers: headers);
    final responseData = json.decode(response.body);
    // _items.clear();
    responseData.forEach((item) {
      addProductSubcategory(classMapToObj(item));
      // _items.add(classMapToObj(item));
    });
    // print('fetchProductSubcategories.length: ${_items.length}');
  }

   static void addProductSubcategory(ProductSubcategory productSubcategory) {
    bool founded = false;
    _items.forEach((subcategory) {
      if (subcategory.id == productSubcategory.id) {
        founded = true;
      }
    });
    if (founded == false) {
      _items.add(productSubcategory);
      _itemsList2.add(productSubcategory);
    }
  }

   static void clearLocalList() {
    _items.clear();
  }

   static ProductSubcategory classMapToObj(Map<String, dynamic> localMap) {
    return ProductSubcategory(
      id: localMap['id'].toString(),
      name: localMap['Name'],
      description: localMap['Description'],
      productCategory: localMap['Product_Category']['id'].toString(),
    );
  }

  static List<ProductSubcategory>
      getProductSubcategoriesByShopProductCategoryId(
          String shopProductCategoryId) {
    List<ProductSubcategory> localList = [];
    print('ProductSubcategorylength is: ${items.length}');
    items.forEach((subcatogory) {
      if (subcatogory.productCategory ==
          ShopProductsCategories.items
              .firstWhere((item) => item.id == shopProductCategoryId)
              .productCategory) {

        localList.add(subcatogory);
      }
    });

    // print('Shabber');
    return localList;
  }
}
