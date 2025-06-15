import 'package:flutter/material.dart';
import 'LoginScreen.dart';
import 'RegisterScreen.dart';
import 'ForgotPasswordScreen.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LoginScreen(),
    routes: {
      '/login': (context) => LoginScreen(),
      '/register': (context) => RegisterScreen(),
      '/forgot': (context) => ForgotPasswordScreen(),
    },
  ));
}
