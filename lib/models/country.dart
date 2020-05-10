import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../providers/conf_data.dart';

class Country {
  final String id;
  final String name;
  final String description;

  Country({
    @required this.id,
    @required this.name,
    @required this.description,
  });
}

class Countries {
  static List<Country> _items = [];

  static List<Country> get items {
    return [..._items];
  }

  static Future<void> fetchCountries() async {
    var url = basic_URL + 'country/';
    final response = await http.get(url, headers: headers);
    final responseData = json.decode(response.body);
    _items.clear();
    responseData.forEach((item) {
      _items.add(classMapToObj(item));
    });
  }

  static Country classMapToObj(Map<String, dynamic> localMap) {
    return Country(
        id: localMap['id'].toString(),
        name: localMap['Name'],
        description: localMap['Description'],
      );
  }
}
