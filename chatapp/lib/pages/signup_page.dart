// ignore_for_file: use_build_context_synchronously

import 'package:chatapp/services/auth/auth_service.dart';
import 'package:chatapp/components/mybutton.dart';
import 'package:chatapp/components/mytext_field.dart';
import 'package:chatapp/services/notification/notification_service.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordController =
      TextEditingController();

  //tap to go to sign up
  final void Function()? onTap;

  SignUpPage({super.key, this.onTap});

  //signup method
  void signUp(BuildContext context) async {
    //auth service and notifications
    final authService = AuthService();
    final notificationService = NotificationService();

    // if passwords match
    if (_passwordController.text == _confirmpasswordController.text) {
      //try signup
      try {
        await authService.signUpwithEmailandPassword(
          _emailController.text,
          _passwordController.text,
          _usernameController.text,
        );
        await notificationService.requestPermission();
        await notificationService.getToken();
        _emailController.clear();
        _usernameController.clear();
        _passwordController.clear();
        _confirmpasswordController.clear();
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
    // if passwords don't match show error
    else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Passwords don't match"),
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
            "Let's create an account!",
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

          //Email
          MyTextField(
            hintText: "Username",
            obscureText: false,
            controller: _usernameController,
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
            height: 10,
          ),

          //Confirm Password
          MyTextField(
            hintText: "Confirm Password",
            obscureText: true,
            controller: _confirmpasswordController,
          ),

          const SizedBox(
            height: 25,
          ),

          //Login Button
          MyButton(
            text: "Register",
            onTap: () => signUp(context),
          ),

          const SizedBox(
            height: 25,
          ),

          //Or Register?
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Already have an account? ",
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
              GestureDetector(
                onTap: onTap,
                child: Text(
                  "Login Here",
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
