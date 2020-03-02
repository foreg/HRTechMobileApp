import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:hrtech/main.dart';

import 'MainPage.dart';


class Routes {
  static final Router _router = new Router();

  static var homeHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return new MainPage();
    });

  static void initRoutes() {
    _router.define("/", handler: homeHandler);
  }

  static void _navigateTo(context, String route, {TransitionType transition=TransitionType.fadeIn, bool clearStack=false}) {
    _router.navigateTo(context, route, transition: transition, clearStack: clearStack);
  }
  static void home(context) {
    Routes._navigateTo(context, '/', clearStack:true);
  }

}