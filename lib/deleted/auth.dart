import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../exceptions/http_exception.dart';
import '../exceptions/success_exception.dart';
import './conf_data.dart';
import '../screens/dashboard.dart';
// import './city.dart';
// import './shop_category.dart';
// import './user.dart';
// import './address.dart';
// import './address_type.dart';
// import './country.dart';
// import './gender.dart';
// import './profile.dart';
// import './profile_status.dart';
// import './shop_status.dart';
// import './product_category.dart';
// import './shop_products_category.dart';
// import './product.dart';
// import './shop_product.dart';
// import './product_brand.dart';
// import './product_subcategory.dart';
// import './product_unit_type.dart';
// import './shops.dart';

class Auth {
  static String _token;
  static DateTime _expiryDate;
  static String _userId;
  static Timer _authTimer;

  static bool get isAuth {
    return token != null;
  }

  static String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  static String get authToken {
    return _token;
  }

  static Future<void> signup(String email, String password) async {
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

  static Future<void> login(
      String email, String password, BuildContext ctx) async {
    var url = basic_URL + 'login/';
    try {
      final response = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: json.encode({
            // 'email': email,
            // 'password': password,
            'email': 's@s.com',
            'password': 'shabber5',
          }));
      final responseData = json.decode(response.body);
      // print(responseData);
      if (responseData['non_field_errors'] != null) {
        throw HttpException(responseData['non_field_errors'][0]);
      }
      _token = responseData['token'];
      // _userId get from 'me' link
      _expiryDate = DateTime.now().add(Duration(hours: 1));
      _autoLogout();
      // notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate.toIso8601String(),
      });
      prefs.setString('userData', userData);
      // print('at end');
      // print(_token);
      await fetchDataFromServer();
      Navigator.of(ctx).popAndPushNamed(DashboardScreen.routeName);
    } catch (error) {
      throw error;
    }
  }

  static Future<void> callMe() async {
    const url = 'https://www.shabber.tech/me/';
    final response = await http.get(url, headers: headers);
    final responseData = json.decode(response.body);
    print('responseData');
    print(responseData['id']);
  }

  static Future<bool> tryAutoLogin(BuildContext ctx) async {
    print('tryAutoLogin called');
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

    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;
    // notifyListeners();
    _autoLogout();
    print('tryAutoLogin called2');
    // Navigator.of(ctx).pushNamed(DashboardScreen.routeName);
    return true;
  }

  static Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    // notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
    prefs.clear();
  }

  static void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }

  static Future<void> fetchLatestData() async {}

  static void fetchDataFromServer() async{
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
  }
}
