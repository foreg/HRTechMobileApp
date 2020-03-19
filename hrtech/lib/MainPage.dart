import 'dart:async';

import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:hrtech/CustomTimer.dart';
import 'package:hrtech/Themes.dart';
import 'package:hrtech/utils.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:hrtech/Preloader.dart';
import 'package:intl/intl.dart';
import 'package:hrtech/ApiRequests.dart';
import 'package:hrtech/models/ClockInOut.dart';
import 'package:hrtech/Routes.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Future<ClockInOut> _clockInOut;
  Future<bool> _isExplanationLetter;
  Timer _timer;
  Duration _start;

  @override
  void initState() {
    _clockInOut = ApiRequests.getEmployeeCurrentStatus();
    _isExplanationLetter = ApiRequests.getIsExplanationLetter();
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

  Widget getExplanationLetterButton(BuildContext context, AsyncSnapshot snapshot) {    
    if (snapshot.connectionState == ConnectionState.done && snapshot.hasData && snapshot.data) { 
      return buildExplanationLetterButton(context, snapshot.data);
    }
    else {
      return Container (height: 70,);
    }
  }

  Widget buildExplanationLetterButton(BuildContext context, bool isExplanationLetter) {
    return Center(
      child: GestureDetector(
        onTap: () => Routes.navigateTo(context, 'explanationLetter'),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50.0),
          child: Container(
            color: CustomColors.primaryColor,
            height: 70,
            width: MediaQuery.of(context).size.width - 50,
            child: Center(
              child: Text('Написать объяснительную', style: CustomTextStyles.bodyText20Bold,),
            ),
          ),
        ),
      ),
    );
  }

  Widget getClockInOutButton(BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) { 
      return buildClockInOutButton(context, snapshot.data);
    }
    else {
      return Shimmer.fromColors(
        baseColor: CustomColors.secondaryColor,
        highlightColor: CustomColors.primaryColor,
        // period: Duration(seconds: 1),
        child: buildClockInOutButton(context, null),
      );
    }
  }

  Widget buildClockInOutButton(BuildContext context, ClockInOut clockInOut) {
    return Center(
      // child: GestureDetector(
      //   onTap: () => _onTap(),
      //   child: 
        child: CustomTimer(clockInOut: clockInOut, onTapCallback: _onTap,),
        // child: ClipOval(
        //   child: Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: Container(
        //       color: (clockInOut != null && clockInOut.type) ? CustomColors.mainButtonColor : CustomColors.mainButtonProgress,
        //       // height: 200.0,
        //       // width: 200.0,
        //       child: Center(
        //         child: clockInOut == null ? Container() : getButtonText(clockInOut)
        //       ),
        //     ),
        //   ),
        // ),
      // ),
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
      return Icon(
        Icons.play_arrow, 
        color: CustomColors.mainButtonColor,
        size: 140,);
    }
  }

  void _onTap() {
    // if (_timer != null) {
    //   _timer.cancel();
    //   _timer = null;
    // }
    ApiRequests.addClockInOut().then((_) => {
      setState(() {        
        _clockInOut = ApiRequests.getEmployeeCurrentStatus();
      })
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 50,
        ),
        Container(
          height: 70,
          child: FutureBuilder(
            future: _isExplanationLetter,
            builder: (context, snapshot) => getExplanationLetterButton(context, snapshot),
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Expanded(
          child: FutureBuilder(
            future: _clockInOut,
            builder: (context, snapshot) => getClockInOutButton(context, snapshot),
          ),
        ),
        Container(
          height: 150,
        )
      ],
    );
  }
}