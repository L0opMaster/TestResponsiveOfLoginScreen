import 'package:flutter/material.dart';
import 'package:test_responsive/response/response_screen.dart';
import 'package:test_responsive/screen/login/login_desktop.dart';
import 'package:test_responsive/screen/login/login_phone.dart';
import 'package:test_responsive/screen/login/login_tablet.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponseScreen(
        mobile: LoginPhone(),
        tablet: LoginTablet(),
        desktop: LoginDesktop(),
      ),
    );
  }
}
