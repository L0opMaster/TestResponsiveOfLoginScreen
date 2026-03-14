import 'package:flutter/material.dart';

class ResponseScreen extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget desktop;
  const ResponseScreen({
    super.key,
    required this.desktop,
    required this.mobile,
    required this.tablet,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1000) {
          return desktop;
        } else if (constraints.maxWidth >= 600) {
          return tablet;
        } else {
          return mobile;
        }
      },
    );
  }
}
