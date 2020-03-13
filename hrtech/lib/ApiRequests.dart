import 'dart:convert';

import 'package:hrtech/Cache.dart';
import 'package:hrtech/models/ClockInOut.dart';
import 'package:hrtech/models/EmployeeWorkTime.dart';
import 'package:hrtech/models/PayStats.dart';
import 'package:hrtech/models/Reason.dart';
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

  static Future<bool> getIsExplanationLetter() async {
    await Future.delayed(Duration(seconds: 2)); // TODO remove this line
    return true;
  }

  static Future<List<Reason>> getReasons() async {
    await Future.delayed(Duration(seconds: 2)); // TODO remove this line
    return [Reason(id: 1, name: 'первая'), Reason(id: 2, name: 'вторая'),];
  }

  static Future<void> addExplanationLetter(String description, int reasonId) async {
    var response = await http.post(host + 'explanationLetters', headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    }, body: jsonEncode({
      'description': description,
      'reason_id': reasonId
    }));
    return response;
  }

  static Future<PayStats> getEmployeePayStats() async {
    PayStats cachedResponse = Cache.get('getEmployeePayStats');
    if (cachedResponse != null) {
      return cachedResponse;
    }
    final response = await http.get(host + 'getEmployeePayStats', headers: {
      'Authorization': 'Bearer $token',
    });
    PayStats payStats = PayStats.fromJson(json.decode(response.body)['data']);
    Cache.add('getEmployeePayStats', payStats);
    return payStats;
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