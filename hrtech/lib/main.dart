import 'package:flutter/material.dart';
import 'package:hrtech/BottomNavigation.dart';

import 'package:hrtech/Routes.dart';

void main() {
  Routes.initRoutes();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HR Tech',
      home: BottomNavigation(),
    );
  }
}
