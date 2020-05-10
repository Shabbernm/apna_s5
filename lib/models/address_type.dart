import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../providers/conf_data.dart';

class AddressType {
  final String id;
  final String name;
  final String description;

  AddressType({
    @required this.id,
    @required this.name,
    @required this.description,
  });
}

class AddressTypes {
  static List<AddressType> _items = [];

  static List<AddressType> get items {
    return [..._items];
  }

  static Future<void> fetchAddressType() async {
    var url = basic_URL + 'addressType/';
    final response = await http.get(url, headers: headers);
    final responseData = json.decode(response.body);
    _items.clear();
    responseData.forEach((item) {
      _items.add(classMapToObj(item));
    });
  }

  static AddressType classMapToObj(Map<String, dynamic> localMap) {
    return AddressType(
        id: localMap['id'].toString(),
        name: localMap['Name'],
        description: localMap['Description'],
      );
  }
}
