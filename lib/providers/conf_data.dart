import 'package:flutter/material.dart';

String conf_token = '';
String basic_URL = 'https://www.shabber.tech/';
var headers = {
  "Content-Type": "application/json",
  // 'Authorization': 'Token 778b2f743f2aebd4d73d2431881a88ba54c53c01',  // a@a
  // 'Authorization': 'Token 2cec59ea0ab80bb6c2865bbe4152a2ccd7f9c04e',  // s@s
  'Authorization': 'Token $conf_token', // s@s
};
bool onceDataIsFetched = false;
BuildContext confContext;
