import 'package:flutter/material.dart';
import 'package:hrtech/BottomNavigation.dart';

import 'package:hrtech/Routes.dart';
import 'package:hrtech/Themes.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  Routes.initRoutes();
  initializeDateFormatting('ru', null);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color.fromRGBO(84, 198, 235, 1),
        textTheme: CustomTextThemes.mainTheme,
      ),
      title: 'HR Tech',
      home: BottomNavigation(),
    );
  }
}
