import 'package:flutter/material.dart';
import 'package:test_responsive/screen/home.dart';
import 'screen/login/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      initialRoute: "/login",

      routes: {
        "/login": (context) => const LoginScreen(),
        "/home": (context) => const HomeScreen(),
      },
    );
  }
}
