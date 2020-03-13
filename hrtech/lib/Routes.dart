import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:hrtech/BottomNavigation.dart';
import 'package:hrtech/ExplanationLetter.dart';
import 'package:hrtech/main.dart';

import 'MainPage.dart';


class Routes {
  static final Router _router = new Router();

  static var _homeHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return new BottomNavigation();
    });

	static var _explanationLetterHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return new ExplanationLetter();
    });

  static void initRoutes() {
    _router.define("/", handler: _homeHandler);
    _router.define("/explanationLetter", handler: _explanationLetterHandler);
  }

  static void _navigateTo(context, String route, {TransitionType transition=TransitionType.fadeIn, bool clearStack=false}) {
    _router.navigateTo(context, route, transition: transition, clearStack: clearStack);
  }
  static void home(context) {
    Routes._navigateTo(context, '/', clearStack:true);
  }

	static navigateTo(context, String route) {
		_navigateTo(context, route);
	}

}