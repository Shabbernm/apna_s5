import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../providers/conf_data.dart';

class ProfileStatus {
  final String id;
  final String name;
  final String description;

  ProfileStatus({
    @required this.id,
    @required this.name,
    @required this.description,
  });
}

class ProfileStatuses {
  static List<ProfileStatus> _items = [];

  static List<ProfileStatus> get items {
    return [..._items];
  }

  static Future<void> fetchProfileStatuses() async {
    var url = basic_URL + 'profileStatus/';
    final response = await http.get(url, headers: headers);
    final responseData = json.decode(response.body);
    _items.clear();
    // print(responseData);
    responseData.forEach((item) {
      _items.add(classMapToObj(item));
    });
  }

  static ProfileStatus classMapToObj(Map<String, dynamic> localMap) {
    return ProfileStatus(
        id: localMap['id'].toString(),
        name: localMap['Name'],
        description: localMap['Description'],
      );
  }
}
