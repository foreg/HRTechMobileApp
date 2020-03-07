import 'dart:convert';

import 'package:hrtech/Cache.dart';
import 'package:hrtech/models/ClockInOut.dart';
import 'package:http/http.dart' as http;

class ApiRequests {
  static final String host = 'https://hr-tech-api.herokuapp.com/api/v1/';

  static String token = 'e8vZeEiMFdygHGuUA0HznzuZw7AzsnOj';

  static Future<ClockInOut> getEmployeeCurrentStatus() async {
    ClockInOut cachedResponse = Cache.get('getEmployeeCurrentStatus');
    if (cachedResponse != null) {
      return cachedResponse;
    }
    final response = await http.get(host + 'getEmployeeCurrentStatus', headers: {
      'Authorization': 'Bearer $token',
    });
    ClockInOut clockInOut = ClockInOut.fromJson(json.decode(response.body)['data']);
    Cache.add('getEmployeeCurrentStatus', clockInOut);
    return clockInOut;
  }

  static Future<void> addClockInOut() async {
    Cache.remove('getEmployeeCurrentStatus');
    var response = await http.post(host + 'clockInOuts', headers: {
      'Authorization': 'Bearer $token',
    });
    return response;
  }

  // static void getToken() async {
  //   final response = await http.post(host + 'tokens', headers: {
  //     'Content-Type': 'application/json',
  //     'Accept': 'application/json',
  //     'Authorization': 'Authorization Basic SXZhbm92SUk6MTIzNDU2',
  //   });
  //   token = json.decode(response.body)['data']['token'];
  // }
}