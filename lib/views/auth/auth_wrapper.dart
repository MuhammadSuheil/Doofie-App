import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../main_screen.dart';
import '../../controller/auth_controller.dart';
import 'login_screen.dart';

class AuthWrapper extends StatelessWidget{
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = AuthController();

    return StreamBuilder<User?>(
      stream: authController.userStream,
      builder: (context, snapshot){
        if (snapshot.connectionState == ConnectionState.waiting){
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasData){
          return const MainScreen();
        }

        else {
          return const LoginScreen();
        }
      });
  }
}