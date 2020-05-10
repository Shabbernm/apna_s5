import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../providers/conf_data.dart';

class Profile {
  final String id;
  final String user;
  final String gender;
  final String fullName;
  final int cnic;
  final String dob;
  final int contact;
  final int otherContacts;
  final String city;
  final String country;
  final bool whatsApp;
  final String profileStatus;
  final String image;
  Profile({
    @required this.id,
    @required this.user,
    @required this.gender,
    @required this.fullName,
    @required this.cnic,
    @required this.dob,
    @required this.contact,
    @required this.otherContacts,
    @required this.city,
    @required this.country,
    @required this.whatsApp,
    @required this.profileStatus,
    @required this.image,
  });
}

class Profiles {
  static Profile _profile;

  static Profile get profile {
    return _profile;
  }

  static Future<void> fetchProfiles() async {
    var url = basic_URL + 'profile/';
    final response = await http.get(url, headers: headers);
    final responseData = json.decode(response.body);
    // print('Gender');
    // print(responseData[0]['gender']);
    if (responseData[0]['gender'] != null) {
      _profile = classMapToObj(responseData[0]);
    } else {
      _profile = Profile(
        id: responseData[0]['id'].toString(),
        user: responseData[0]['user'].toString(),
        gender: null,
        fullName: null,
        cnic: null,
        dob: null,
        contact: null,
        otherContacts: null,
        city: null,
        country: null,
        whatsApp: null,
        profileStatus: null,
        image: null,
      );
    }
    // print('_profile');
    // print(_profile);
  }

  static Profile classMapToObj(Map<String, dynamic> localMap) {
    return Profile(
        id: localMap['id'].toString(),
        user: localMap['user'].toString(),
        gender: localMap['gender']['id'],
        fullName: localMap['Full_Name'],
        cnic: localMap['CNIC'],
        dob: localMap['DOB'],
        contact: localMap['contact'],
        otherContacts: localMap['other_contacts'],
        city: localMap['city']['id'],
        country: localMap['country']['id'],
        whatsApp: localMap['WhatsApp'],
        profileStatus: localMap['Profile_Status'],
        image: localMap['image'],
      );
  }
}
