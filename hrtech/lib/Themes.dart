import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

const Color lightGreen = const Color.fromRGBO(6, 214, 160, 1);
const Color lightGrey = const Color.fromRGBO(215, 222, 228, 1);

const Color orange = const Color(0xFFFFA400);
const Color orangeAccent = const Color(0xFFFFD49D);
const Color darkBlue = const Color(0xFF2D3047);
const Color whiteBlue = const Color(0xFFEAF6FF);



class CustomColors {
  const CustomColors();

  static const Color mainButtonColor = lightGreen;
  static const Color mainButtonProgress = lightGrey;

  static const Color primaryColor = orange;
  static const Color primaryColorAccent = orangeAccent;
  static const Color secondaryColor = whiteBlue;
  static const Color backgroundColor = darkBlue;
}

class CustomTextStyles {
  const CustomTextStyles();

  static const TextTheme mainTheme = const TextTheme(headline: TextStyle(color: lightGrey, fontSize: 30));


  static const TextStyle bodyText14 = const TextStyle(color: darkBlue, fontSize: 14);
  static const TextStyle bodyText18 = const TextStyle(color: darkBlue, fontSize: 18);
  static const TextStyle bodyText18White = const TextStyle(color: whiteBlue, fontSize: 18);
  static const TextStyle bodyText18Bold = const TextStyle(color: darkBlue, fontSize: 18, fontWeight: FontWeight.w700);
  static const TextStyle bodyText20 = const TextStyle(color: darkBlue, fontSize: 20);
  static const TextStyle bodyText20White = const TextStyle(color: whiteBlue, fontSize: 20);
  static const TextStyle bodyText20Bold = const TextStyle(color: darkBlue, fontSize: 20, fontWeight: FontWeight.w700);

  static const TextStyle headerText24 = const TextStyle(color: darkBlue, fontSize: 24);
  static const TextStyle headerText24White = const TextStyle(color: whiteBlue, fontSize: 24);
  static const TextStyle headerText24Bold = const TextStyle(color: darkBlue, fontSize: 24, fontWeight: FontWeight.w700);
  static const TextStyle headerText26 = const TextStyle(color: darkBlue, fontSize: 26);
  static const TextStyle headerText26White = const TextStyle(color: whiteBlue, fontSize: 26);
  static const TextStyle headerText26Bold = const TextStyle(color: darkBlue, fontSize: 26, fontWeight: FontWeight.w700);

  static const TextStyle headerText36Inversed = const TextStyle(color: orange, fontSize: 36);
  static const TextStyle headerText96Inversed = const TextStyle(color: orange, fontSize: 96);
  // static const TextStyle headerText96Bold = const TextStyle(color: darkBlue, fontSize: 96, fontWeight: FontWeight.w700);
}