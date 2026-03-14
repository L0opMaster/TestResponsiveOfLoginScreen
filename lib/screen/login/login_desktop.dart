import 'package:flutter/material.dart';
import 'package:test_responsive/widget/login_leftside.dart';
import 'package:test_responsive/widget/login_rightside.dart';

class LoginDesktop extends StatelessWidget {
  const LoginDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 15.0,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [LoginLeftside(), SizedBox(width: 15), LoginForm()],
            ),
          ),
        ),
      ),
    );
  }
}
