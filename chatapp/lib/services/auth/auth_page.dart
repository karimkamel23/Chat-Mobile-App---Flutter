import 'package:chatapp/services/auth/login_or_register.dart';
import 'package:chatapp/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //user logged in already
          if (snapshot.hasData) {
            return const HomePage();
          }
          // user NOT logged in

          else {
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}
