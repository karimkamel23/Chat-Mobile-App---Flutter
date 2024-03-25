import 'package:chatapp/pages/login_page.dart';
import 'package:chatapp/pages/signup_page.dart';
import 'package:flutter/material.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  // initialy show login page
  bool showLoginPage = true;

  //toggle between login and register pages
  void togglePageView() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(
        onTap: togglePageView,
      );
    } else {
      return SignUpPage(
        onTap: togglePageView,
      );
    }
  }
}
