import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

const Color lightGreen = const Color.fromRGBO(6, 214, 160, 1);
const Color lightGrey = const Color.fromRGBO(215, 222, 228, 1);

class CustomColors {
  const CustomColors();

  static const Color mainButtonColor = lightGreen;
  static const Color mainButtonProgress = lightGrey;
}

class CustomTextThemes {
  const CustomTextThemes();

  static const TextTheme mainTheme = const TextTheme(headline6: TextStyle(color: lightGrey, fontSize: 30));
}