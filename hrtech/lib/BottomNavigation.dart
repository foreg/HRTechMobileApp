import 'package:flutter/material.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:hrtech/CustomIcons.dart';

import 'package:hrtech/MainPage.dart';
import 'package:hrtech/PayStatsPage.dart';
import 'package:hrtech/Themes.dart';
import 'package:hrtech/WorkTime.dart';


class BottomNavigation extends StatefulWidget {
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int currentPage = 1;

  _getPage(int page) {
    switch (page) {
      case 0:
        return WorkTime();
      case 1:
        return MainPage();
      case 2:
        return PayStatsPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgroundColor,
      body: SafeArea(
        child: Container(
          child: Center(
            child: _getPage(currentPage),
          ),
        ),
      ),
      bottomNavigationBar: FancyBottomNavigation(
        activeIconColor: CustomColors.backgroundColor,
        inactiveIconColor: CustomColors.backgroundColor,
        circleColor: CustomColors.primaryColor,
        barBackgroundColor: CustomColors.secondaryColor,
        textColor: CustomColors.backgroundColor,

        initialSelection: 1,
        tabs: [
          TabData(iconData: CustomIcons.bar_chart, title: "Рабочее время"),
          TabData(iconData: CustomIcons.clock, title: "Главная"),
          TabData(iconData: CustomIcons.ruble, title: "История выплат")
        ],
        onTabChangedListener: (position) {
          setState(() {
            currentPage = position;
          });
        },
      ),
    );
  }
}