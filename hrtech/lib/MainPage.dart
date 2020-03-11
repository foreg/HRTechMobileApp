import 'dart:async';

import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:hrtech/utils.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:hrtech/Preloader.dart';
import 'package:intl/intl.dart';
import 'package:hrtech/ApiRequests.dart';
import 'package:hrtech/models/ClockInOut.dart';
import 'Routes.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Future<ClockInOut> _clockInOut;
  Timer _timer;
  Duration _start;

  @override
  void initState() {
    _clockInOut = ApiRequests.getEmployeeCurrentStatus();
    super.initState();
  }

  @override
  void dispose() {
    if (_timer != null)
      _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(() {
        _start = _start + oneSec;
        },
      ),
    );
  }

  Widget getClockInOutButton(AsyncSnapshot snapshot) {    
    if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) { 
      return buildClockInOutButton(snapshot.data);
    }
    else {
      return Shimmer.fromColors(
        baseColor: Colors.red,
        highlightColor: Colors.green,
        // period: Duration(seconds: 1),
        child: buildClockInOutButton(null),
      );
    }
  }

  Widget buildClockInOutButton(ClockInOut clockInOut) {
    return Center(
      child: GestureDetector(
        onTap: () => _onTap(),
        child: ClipOval(
          child: Container(
            color: (clockInOut != null && clockInOut.type) ? Colors.green : Colors.red,
            height: 200.0,
            width: 200.0,
            child: Center(
              child: clockInOut == null ? Container() : getButtonText(clockInOut)
            ),
          ),
        ),
      ),
    );
  }

  Widget getButtonText(ClockInOut clockInOut) {
    if (clockInOut.type) {
      if (_timer == null) {
        _start = DateTime.now().difference(clockInOut.checkTime);
        startTimer();
      }
      return Text(printDuration(_start));
    }
    else {
      return Text('Начать работать');
    }
  }

  void _onTap() {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
    ApiRequests.addClockInOut().then((_) => {
      setState(() {        
        _clockInOut = ApiRequests.getEmployeeCurrentStatus();
      })
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _clockInOut,
      builder: (context, snapshot) => getClockInOutButton(snapshot),
    );
  }
}