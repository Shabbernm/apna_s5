import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../providers/conf_data.dart';

class City {
  final String id;
  final String name;
  final String description;

  City({
    @required this.id,
    @required this.name,
    @required this.description,
  });
}

class Cities {
  static List<City> _items = [];

  static List<City> get items {
    return [..._items];
  }

  static Future<void> fetchCities() async {
    var url = basic_URL + 'city/';
    final response = await http.get(url, headers: headers);
    final responseData = json.decode(response.body);
    _items.clear();
    _items.add(City(
      id: '0',
      name: 'Select City',
      description: '-----',
    ));
    responseData.forEach((item) {
      _items.add(classMapToObj(item));
    });
  }

  static City classMapToObj(Map<String, dynamic> localMap) {
    return City(
        id: localMap['id'].toString(),
        name: localMap['Name'],
        description: localMap['Description'],
      );
  }
}
