import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../providers/conf_data.dart';

class Address {
  final String id;
  final String profile;
  final String addressType;
  final String address;
  final String city;
  final String location;

  Address({
    @required this.id,
    @required this.profile,
    @required this.addressType,
    @required this.address,
    @required this.city,
    @required this.location,
  });
}

class Addresses {
  static List<Address> _items = [];

  static List<Address> get items {
    return [..._items];
  }

  static Future<void> fetchAddresses() async {
    var url = basic_URL + 'address/';
    final response = await http.get(url, headers: headers);
    final responseData = json.decode(response.body);
    _items.clear();
    responseData.forEach((item) {
      _items.add(classMapToObj(item));
    });
  }

  static Address classMapToObj(Map<String, dynamic> localMap) {
    return Address(
        id: localMap['id'].toString(),
        profile: localMap['Profile'].toString(),
        addressType: localMap['Address_Type']['Name'],
        address: localMap['address1'],
        city: localMap['city']['Name'],
        location: localMap['location'],
      );
  }
}
