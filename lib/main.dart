import 'package:flutter/material.dart';
import 'package:test_responsive/screen/home.dart';
// import 'package:test_responsive/screen/order/customer_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // initialRoute: "/login",
      home: HomeScreen(),

      // routes: {
      //   "/login": (context) => const LoginScreen(),
      //   "/home": (context) => const HomeScreen(),
      // },
    );
  }
}
