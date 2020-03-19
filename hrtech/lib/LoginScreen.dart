import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:hrtech/ApiRequests.dart';
import 'package:hrtech/BottomNavigation.dart';
import 'package:hrtech/Themes.dart';

const users = const {
  'dribbble@gmail.com': '12345',
  'hunter@gmail.com': 'hunter',
};

class LoginScreen extends StatelessWidget {
  Duration get loginTime => Duration(milliseconds: 250);

  Future<String> _authUser(LoginData data) {
    print('Name: ${data.name}, Password: ${data.password}');
    return ApiRequests.getToken(data.name, data.password).then((result) {
      if (!result) {
        return 'Неверная пара логин/пароль';
      }
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'HR Tech',
      messages: LoginMessages(
        usernameHint: 'Имя пользователя',
        passwordHint: 'Пароль',
        loginButton: 'Войти'
      ),
      theme: LoginTheme(
        primaryColor: CustomColors.backgroundColor,
        accentColor: CustomColors.primaryColor,
        cardTheme: CardTheme(
          color: CustomColors.secondaryColor
        ),
        buttonStyle: CustomTextStyles.bodyText18White
      ),
      emailValidator: (s) => s.length == 0 ? 'Неверное имя пользователя' : null,
      passwordValidator: (s) => s.length == 0 ? 'Неверный пароль' : null,
      // logo: 'assets/images/ecorp-lightblue.png',
      onLogin: _authUser,
      onSignup: null,
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => BottomNavigation(),
        ));
      },
      onRecoverPassword: null,
    );
  }
}