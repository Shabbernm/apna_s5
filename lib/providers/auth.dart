import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:apna_s5/models/address.dart';
import 'package:apna_s5/models/order_status.dart';
import 'package:apna_s5/models/product_brand.dart';
import 'package:apna_s5/models/product_unit_type.dart';
import 'package:apna_s5/models/shop_product.dart';
import 'package:flutter/material.dart';

import '../models/address_type.dart';
import '../models/city.dart';
import '../models/product.dart';
import '../models/product_category.dart';
import '../models/product_subcategory.dart';
import '../models/profile.dart';
import '../models/shop_category.dart';
import '../models/shop_products_category.dart';
import '../models/shop_status.dart';
import '../models/shops.dart';
import '../models/user.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../exceptions/http_exception.dart';
import '../exceptions/success_exception.dart';
import './conf_data.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

  bool get isAuth {
    bool check = token != null;
    if (check) {
      // set token
      conf_token = token;
      // _fetchOnce();
    }
    return check;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> signup(String email, String password) async {
    var url = basic_URL + 'signup/';
    const url2 =
        "https://api.darksky.net/forecast/3c86c7d5b041f9cfda364001b1dcfce8/37.8267,-122.4233";
    try {
      final response = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: json.encode({
            'email': email,
            'password': password,
            'user_type': 'shop',
          }));
      final responseData = json.decode(response.body);
      print(responseData);
      print(responseData['id']);
      if (responseData['email'][0] == 'user with this email already exists.') {
        print('in signup email');
        throw HttpException(responseData['email'][0]);
      }
      if (responseData['password'] != null) {
        print('in signup password');
        throw HttpException(responseData['password'][0]);
      }
      if (responseData['id'] != null) {
        print('in signup id');
        throw SuccessException('Created Sucessfully');
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> login(String email, String password) async {
    var url = basic_URL + 'login/';
    try {
      final response = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: json.encode({
            'email': 's@s.com',
            'password': 'shabber5',
          }));
      final responseData = json.decode(response.body);
      print(responseData);
      if (responseData['non_field_errors'] != null) {
        print(HttpException(responseData['non_field_errors'][0]));
        throw HttpException(responseData['non_field_errors'][0]);
      }
      _token = responseData['token'];
      conf_token = _token;
      // _userId get from 'me' link
      _expiryDate = DateTime.now().add(Duration(hours: 1));
      _autoLogout();
      // _fetchOnce();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate.toIso8601String(),
      });
      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> callMe() async {
    const url = 'https://www.shabber.tech/me/';

    final response = await http.get(url, headers: headers);
    final responseData = json.decode(response.body);
    print('responseData');
    print(responseData['id']);
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    // _fetchOnce();

    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;
    conf_token = _token;
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;

    conf_token = '';
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
    prefs.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }

  Future<void> fetchOnce() async {
    print(DateTime.now());
    onceDataIsFetched = true;
    await Shops.fetchShops();
    if (Shops.items.length > 0) {
      await _fetchSetupTables();
      await _fetchUserData();
      // if (ShopCategories.items
      //         .firstWhere((item) => item.id == Shops.items[0].shopCategory)
      //         .name ==
      //     'Grocery Shop') {
      //   await ProductCategories.fetchProductsCategories();
      //   await ShopProductsCategories.fetchShopProductsCategories();
      //   // fetch all shop subcategories
      //   // fetch shop product subcateories
      //   await ProductSubcategories.fetchProductSubcategories();

      //   ProductSubcategories.items.forEach((productSubcategory) async {
      //     await Products.fetchProducts(productSubcategory.id);
      //   });

      //   ShopProductsCategories.items.forEach((shopProductsCategory) async {
      //     await ShopProducts.fetchShopProducts(shopProductsCategory.id);
      //     print(ShopProducts.items.length);
      //   });

      // } else {
      // await _fetchSetupTables();
      // await _fetchUserData();

      // compulsory
      await ProductCategories.fetchProductsCategories();
      // print(ProductCategories.items.length);
      await ShopProductsCategories.fetchShopProductsCategories();
      // print(ShopProductsCategories.items.length);
      await ProductSubcategories.fetchProductSubcategories();
      // print(ProductSubcategories.items.length);

      ProductSubcategories.items.forEach((productSubcategory) async {
        // print('productSubcategory.id: ${productSubcategory.id}');
        await Products.fetchProducts(productSubcategory.id);
        // print('Products.items.length: ${Products.items.length}');
      });

      ShopProductsCategories.items.forEach((shopProductsCategory) async {
        await ShopProducts.fetchShopProducts(shopProductsCategory.id);
        // print(ShopProducts.items.length);
      });
      // }

      // same category products
      // Products.fetchProducts(productSubcategoryId);

      // ProductSubcategories.items.forEach((productSubcategory) async {
      //   print('productSubcategory.id: ${productSubcategory.id}');
      //   await Products.fetchProducts(productSubcategory.id);
      // });
      // print('Products.items.length: ${Products.items.length}');

      // await ProductBrands.fetchProductBrands();
    } else {
      // fetch setup
      await _fetchSetupTables();
      await _fetchUserData();
    }

    // Cities.fetchCities();
    // await Shops.fetchShops();
    // ShopCategories.fetchShopCategories();
    // Users.fetchUser();
    // Addresses.fetchAddresses();
    // Countries.fetchCountries();
    // Genders.fetchGenders();
    // ProfileStatuses.fetchProfileStatuses();
    // Profiles.fetchProfiles();
    // AddressTypes.fetchAddressType();
    // ShopStatuses.fetchShopStatuses();
    // ProductBrands.fetchProductBrands();
    // ProductSubcategories.fetchProductSubcategories();
    // ProductUnitTypes.fetchProductUnitTypes();
    // await ProductCategories.fetchProductsCategories();
    // ShopProductsCategories.fetchShopProductsCategories();
    // await Products.fetchProducts();
    // ShopProducts.fetchShopProducts();
    
    print(DateTime.now());
  }

  Future<void> _fetchSetupTables() async {
    // setup tables
    ShopCategories.fetchShopCategories();
    Cities.fetchCities();
    AddressTypes.fetchAddressType();
    ShopStatuses.fetchShopStatuses();
    OrderStatuses.fetchOrderStatuses();
    // ProductUnitTypes.fetchProductUnitTypes();
  }

  Future<void> _fetchUserData() async {
    await Profiles.fetchProfiles();
    await Users.fetchUser();
    await Addresses.fetchAddresses();
  }
}
