import 'package:flutter/material.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';

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
      appBar: AppBar(
        textTheme: CustomTextThemes.mainTheme,
        title: Text("HR Tech"),
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Center(
          child: _getPage(currentPage),
        ),
      ),
      bottomNavigationBar: FancyBottomNavigation(
        initialSelection: 1,
        tabs: [
          TabData(iconData: Icons.home, title: "Home"),
          TabData(iconData: Icons.home, title: "Главная"),
          TabData(iconData: Icons.shopping_cart, title: "Basket")
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