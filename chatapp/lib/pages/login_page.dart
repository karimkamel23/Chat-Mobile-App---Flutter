// ignore_for_file: use_build_context_synchronously

import 'package:chatapp/services/auth/auth_service.dart';
import 'package:chatapp/components/mybutton.dart';
import 'package:chatapp/components/mytext_field.dart';
import 'package:chatapp/services/notification/notification_service.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  //email and passsword controllers:
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  //tap to go to sign up
  final void Function()? onTap;

  LoginPage({super.key, this.onTap});

  //login method
  void login(BuildContext context) async {
    // auth service and notifications
    final authService = AuthService();
    final notificationService = NotificationService();

    //try login
    try {
      await authService.signInWithEmailandPassword(
        _emailController.text,
        _passwordController.text,
      );

      await notificationService.requestPermission();
      await notificationService.getToken();
    }
    //catch errors
    catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //Logo
          Icon(
            Icons.message,
            size: 60,
            color: Theme.of(context).colorScheme.primary,
          ),

          const SizedBox(
            height: 50,
          ),

          //welcome back!
          Text(
            "Welcome back, we missed you!",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 16,
            ),
          ),

          const SizedBox(
            height: 25,
          ),

          //Email
          MyTextField(
            hintText: "Email",
            obscureText: false,
            controller: _emailController,
          ),

          const SizedBox(
            height: 10,
          ),

          //Password
          MyTextField(
            hintText: "Password",
            obscureText: true,
            controller: _passwordController,
          ),

          const SizedBox(
            height: 25,
          ),

          //Login Button
          MyButton(
            text: "Login",
            onTap: () => login(context),
          ),

          const SizedBox(
            height: 25,
          ),

          //Or Register?
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Not a member? ",
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
              GestureDetector(
                onTap: onTap,
                child: Text(
                  "Register Now",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
