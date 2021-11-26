import 'package:flutter/material.dart';

class AppNavigator {
  Widget nextScreen;
  BuildContext context;
  AppNavigator({
    required this.nextScreen,
    required this.context,
  });

  void navigateToNext() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => nextScreen),
    );
  }
}
