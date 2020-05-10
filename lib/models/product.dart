import 'dart:convert';
import 'package:apna_s5/models/product_brand.dart';
import 'package:apna_s5/models/product_subcategory.dart';
import 'package:apna_s5/models/product_unit_type.dart';
import 'package:apna_s5/providers/conf_data.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product {
  final String id;
  final String name;
  final String productSubcategory;
  final String productBrand;
  final String productUnitType;
  final String description;
  final int barcode;
  final String image;
  final String slug;
  bool available;

  Product({
    @required this.id,
    @required this.name,
    @required this.productSubcategory,
    @required this.productBrand,
    @required this.productUnitType,
    @required this.description,
    @required this.barcode,
    @required this.image,
    @required this.slug,
    this.available = false,
  });
}

class Products {
  static List<Product> _items = [];
  static List<Product> _itemsList2 = [];

  static List<Product> get items {
    return [..._items];
  }

  static List<Product> get itemsList2 {
    return [..._itemsList2];
  }

  static Future<void> fetchProducts(String productSubcategoryId) async {
    var url = basic_URL + 'product/?productSubcategoryId=$productSubcategoryId';
    final response = await http.get(url, headers: headers);
    final responseData = json.decode(response.body);
    // _items.clear();
    responseData.forEach((item) {
      addProductToLocalList(classMapToObj(item));
      // _items.add(classMapToObj(item));
    });

    // print('fetchProducts');
    // print(_items.length);
  }

  static void addProductToLocalList(Product prod) {
    bool prodFound = false;
    _items.forEach((item) {
      if (item.id == prod.id) {
        prodFound = true;
      }
    });
    if (prodFound == false) {
      _items.add(prod);
      _itemsList2.add(prod);
    }
  }

  static void clearLocalList() {
    _items.clear();
  }

  static Product classMapToObj(Map<String, dynamic> localMap) {
    // add Product_Subcategory
    // ProductSubcategories.addProductSubcategory(
    //     ProductSubcategories.classMapToObj(localMap['Product_Subcategory']));
    // add Product_Brand
    ProductBrands.addProductBrand(
        ProductBrands.classMapToObj(localMap['Product_Brand']));
    // add Product_Unit_Type
    ProductUnitTypes.addProductUnitType(
        ProductUnitTypes.classMapToObj(localMap['Product_Unit_Type']));

    return Product(
      id: localMap['id'].toString(),
      name: localMap['name'],
      productSubcategory: localMap['Product_Subcategory']['id'].toString(),
      productBrand: localMap['Product_Brand']['id'].toString(),
      productUnitType: localMap['Product_Unit_Type']['id'].toString(),
      description: localMap['description'],
      barcode: localMap['barcode'],
      image: localMap['image'],
      slug: localMap['slug'],
    );
  }
}
