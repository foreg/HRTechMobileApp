import 'dart:convert';

import 'package:hrtech/Cache.dart';
import 'package:hrtech/models/ClockInOut.dart';
import 'package:hrtech/models/EmployeeWorkTime.dart';
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

  static Future<EmployeeWorkTime> getEmployeeWorkTime(String step, DateTime startDate) async {
    String startDateString = startDate.toIso8601String();
    String request = 'getEmployeeWorkTime' + '?' + 'step=$step&startDate=$startDateString';
    var date;
    switch (step) {
      case 'week':
        date = startDate.year.toString() + '-' +  startDate.month.toString() + '-' +  startDate.day.toString();
        break;
      case 'month':
        date = startDate.year.toString() + '-' +  startDate.month.toString();
        break;
      default: 
        date = startDate.year.toString();
    }
    String cacheKey = 'getEmployeeWorkTime' + '?' + 'step=$step&startDate=$date';
    EmployeeWorkTime cachedResponse = Cache.get(cacheKey);
    if (cachedResponse != null) {
      return cachedResponse;
    }
    final response = await http.get(host + request, headers: {
      'Authorization': 'Bearer $token',
    });
    print(host + cacheKey);
    EmployeeWorkTime employeeWorkTime = EmployeeWorkTime.fromJson(json.decode(response.body)['data']);
    Cache.add(cacheKey, employeeWorkTime);
    return employeeWorkTime;
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