import 'package:flutter/material.dart';

import 'MainPage.dart';
import 'Routes.dart';

void main() {
  Routes.initRoutes();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HR Tech',
      home: MainPage(),
    );
  }
}
