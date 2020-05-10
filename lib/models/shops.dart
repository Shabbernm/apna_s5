import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import '../providers/conf_data.dart';
import '../models/address.dart';
import '../models/address_type.dart';
import '../models/city.dart';
import '../models/product.dart';
import '../models/product_category.dart';
import '../models/product_subcategory.dart';
import '../models/profile.dart';
import '../models/shop_category.dart';
import '../models/shop_product.dart';
import '../models/shop_products_category.dart';
import '../models/shop_status.dart';
import '../models/user.dart';

class Shop {
  String shopId;
  String shopCategory;
  String name;
  String address;
  String city;
  String location;
  String openingTime;
  String closingTime;
  double minimumOrder;
  double maximumOrder;
  double deliveryCharges;
  String slug;
  String shopStatus;

  Shop({
    @required this.shopId,
    @required this.shopCategory,
    @required this.name,
    @required this.address,
    @required this.city,
    @required this.location,
    @required this.openingTime,
    @required this.closingTime,
    @required this.minimumOrder,
    @required this.maximumOrder,
    @required this.deliveryCharges,
    @required this.slug,
    @required this.shopStatus,
  });
}

class Shops {
  static List<Shop> _items = [];
  static List<Shop> _itemsList2 = [];

  static List<Shop> get items {
    return [..._items];
  }

  static List<Shop> get itemsList2 {
    return [..._itemsList2];
  }

  static Future<List<Shop>> fetchShops() async {
    // print('fetchShops');
    var url = basic_URL + 'allShops/';

    var response = await http.get(url, headers: headers);
    var responseData = json.decode(response.body);

    _items.clear();
    responseData.forEach((shop) {
      var ashop = classMapToObj(shop);
      _items.add(ashop);
      addShopList2(ashop);
    });

    return items;
  }

  static Future<int> addShop(Shop shopObj) async {
    int addressId =
        await addAddress(shopObj.address, shopObj.city, shopObj.location);

    var url = basic_URL + 'allShops/';
    // print('shopCategory');
    // print(shopObj.shopCategory);
    var body = json.encode({
      'user': Users.user.id,
      'Shop_Category': shopObj.shopCategory,
      'name': shopObj.name,
      'Address': addressId,
      'OpeningTime': shopObj.openingTime,
      'ClosingTime': shopObj.closingTime,
      'MinimumOrder': shopObj.minimumOrder,
      'MaximumOrder': shopObj.maximumOrder,
      'DeliveryCharges': shopObj.deliveryCharges,
      'Shop_Status':
          ShopStatuses.items.firstWhere((item) => item.name == 'Pending').id,
    });
    var response = await http.post(url, headers: headers, body: body);
    var responseData = json.decode(response.body);
    // print(responseData);
    await _addShopToList(responseData);

    if (ShopCategories.items
            .firstWhere((item) => item.id == shopObj.shopCategory)
            .name ==
        'Grocery Shop') {
      await ProductCategories.fetchProductsCategories();

      // await ShopProductsCategories.insertShopProductsCategory(
      //     responseData['id'].toString(), ProductCategories.items[0].id);

      // await ShopProductsCategories.fetchShopProductsCategories();
      // print(
      //     'ShopProductsCategories.items.length: ${ShopProductsCategories.items.length}');
      // await ProductSubcategories.fetchProductSubcategories();
      // print(
      //     'ProductSubcategories.items.length: ${ProductSubcategories.items.length}');

      // ProductSubcategories.items.forEach((productSubcategory) async {
      //   await Products.fetchProducts(productSubcategory.id);
      // });
    } else {
      await ProductCategories.fetchProductsCategories();

      // String productCategoryId = ProductCategories.items
      //     .firstWhere((item) =>
      //         item.shopCategory ==
      //         ShopCategories.items
      //             .firstWhere((item) => item.id == shopObj.shopCategory)
      //             .id)
      //     .id;
      await ShopProductsCategories.insertShopProductsCategory(
          responseData['id'].toString(), ProductCategories.items[0].id);
      await ShopProductsCategories.fetchShopProductsCategories();
      print(
          'ShopProductsCategories.items.length: ${ShopProductsCategories.items.length}');
      await ProductSubcategories.fetchProductSubcategories();
      print(
          'ProductSubcategories.items.length: ${ProductSubcategories.items.length}');

      ProductSubcategories.items.forEach((productSubcategory) async {
        await Products.fetchProducts(productSubcategory.id);
      });
    }

    return responseData['id'];
  }

  static Future<int> addAddress(
      String address, String city, String location) async {
    var url = basic_URL + 'address/';
    var body = json.encode({
      'Profile': Profiles.profile.id,
      'Address_Type': AddressTypes.items
          .firstWhere((item) => item.name == 'Shop Address')
          .id,
      'address1': address,
      'city': Cities.items.firstWhere((item) => item.name == city).id,
      'location': location,
    });
    var response = await http.post(url, headers: headers, body: body);
    var responseData = json.decode(response.body);
    return responseData['id'];
  }

  static Future<int> updateShop(Shop shopObj) async {
    String addressId = Addresses.items
        .firstWhere((item) => item.addressType == 'Shop Address')
        .id;
    await updateAddress(
        addressId, shopObj.address, shopObj.city, shopObj.location);
    var url = basic_URL + 'allShops/${shopObj.shopId}/';
    // print('shopCategory');
    // print(shopObj.shopCategory);
    // print(ShopCategories.items.length);
    var body = json.encode({
      'id': shopObj.shopId,
      'user': Users.user.id,
      'Shop_Category': shopObj.shopCategory,
      'name': shopObj.name,
      'Address': addressId,
      'OpeningTime': shopObj.openingTime,
      'ClosingTime': shopObj.closingTime,
      'MinimumOrder': shopObj.minimumOrder,
      'MaximumOrder': shopObj.maximumOrder,
      'DeliveryCharges': shopObj.deliveryCharges,
      'Shop_Status': ShopStatuses.items
          .firstWhere((item) => item.name == shopObj.shopStatus)
          .id,
    });
    var response = await http.put(url, headers: headers, body: body);
    var responseData = json.decode(response.body);
    // print('updateShop');
    // print(responseData);
    return responseData['id'];
  }

  static Future<int> updateAddress(
      String addressId, String address, String city, String location) async {
    var url = basic_URL + 'address/$addressId/';
    var body = json.encode({
      'id': addressId,
      'Profile': Profiles.profile.id,
      'Address_Type': AddressTypes.items
          .firstWhere((item) => item.name == 'Shop Address')
          .id,
      'address1': address,
      'city': Cities.items.firstWhere((item) => item.name == city).id,
      'location': location,
    });
    var response = await http.put(url, headers: headers, body: body);
    var responseData = json.decode(response.body);
    // print('updateAddress');
    // print(responseData);
    return responseData['id'];
  }

  static Shop getShop(String shopSlug) {
    Shop obj;
    items.forEach((item) {
      if (item.slug == shopSlug) {
        // print('category');
        // print(item.shopCategory);
        obj = item;
      }
    });
    return obj;
  }

  static Future<List<Shop>> fetchShopsByCategoryId(
      String catId, Map<String, dynamic> locationMap) async {
    // print('Shabber mast');
    var url = basic_URL +
        "getShopsByLocation/?shopCategoryId=$catId&latitude=${locationMap['latitude']}&longitude=${locationMap['longitude']}&distance=1.5";

    var response = await http.get(url, headers: headers);
    var responseData = json.decode(response.body);
    _items.clear();
    responseData.forEach((shop) {
      var ashop = classMapToObj(shop);
      _items.add(ashop);
      addShopList2(ashop);
    });
    // print(items);
    return items;
  }

  static void addShopList2(Shop passedShop) {
    bool found = false;
    _itemsList2.forEach((shop) {
      if (shop.shopId == passedShop.shopId) {
        found = true;
      }
    });
    if (found == false) {
      _itemsList2.add(passedShop);
    }
  }

  static Shop classMapToObj(Map<String, dynamic> localMap) {
    return Shop(
      shopId: localMap['id'].toString(),
      shopCategory: localMap['Shop_Category']['id'].toString(),
      name: localMap['name'],
      address: localMap['Address']['address1'],
      city: localMap['Address']['city']['Name'],
      location: localMap['Address']['location'],
      openingTime: localMap['OpeningTime'],
      closingTime: localMap['ClosingTime'],
      minimumOrder: double.parse(localMap['MinimumOrder']),
      maximumOrder: double.parse(localMap['MaximumOrder']),
      deliveryCharges: double.parse(localMap['DeliveryCharges']),
      slug: localMap['slug'],
      shopStatus: localMap['Shop_Status']['Name'],
    );
  }

  static Future<void> _addShopToList(Map<String, dynamic> data) {
    _items.add(Shop(
      shopId: data['id'].toString(),
      shopCategory: data['Shop_Category'].toString(),
      name: data['name'],
      address: data['Address'].toString(),
      city: '',
      location: '',
      openingTime: data['OpeningTime'],
      closingTime: data['ClosingTime'],
      minimumOrder: double.parse(data['MinimumOrder']),
      maximumOrder: double.parse(data['MaximumOrder']),
      deliveryCharges: double.parse(data['DeliveryCharges']),
      slug: data['slug'],
      shopStatus: data['Shop_Status'].toString(),
    ));
  }
}
