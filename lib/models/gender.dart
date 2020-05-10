import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../providers/conf_data.dart';

class Gender {
  final String id;
  final String name;
  final String description;

  Gender({
    @required this.id,
    @required this.name,
    @required this.description,
  });
}

class Genders {
  static List<Gender> _items = [];

  static List<Gender> get items {
    return [..._items];
  }

  static Future<void> fetchGenders() async {
    var url = basic_URL + 'gender/';
    final response = await http.get(url, headers: headers);
    final responseData = json.decode(response.body);
    _items.clear();
    responseData.forEach((item) {
      _items.add(classMapToObj(item));
    });
  }

  static Gender classMapToObj(Map<String, dynamic> localMap) {
    return Gender(
        id: localMap['id'].toString(),
        name: localMap['Name'],
        description: localMap['Description'],
      );
  }
}
