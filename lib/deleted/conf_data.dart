import './auth.dart';

String basic_URL = 'https://www.shabber.tech/';
var headers = {
  "Content-Type": "application/json",
  'Authorization': 'Token ${Auth.authToken}'
};
