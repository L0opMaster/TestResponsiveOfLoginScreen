import 'package:flutter/material.dart';
import 'package:test_responsive/widget/login_rightside.dart';

class LoginPhone extends StatefulWidget {
  const LoginPhone({super.key});

  @override
  State<LoginPhone> createState() => _LoginPhoneState();
}

class _LoginPhoneState extends State<LoginPhone> {
  @override
  Widget build(BuildContext context) {
    return Center(child: SingleChildScrollView(child: LoginForm()));
  }
}
