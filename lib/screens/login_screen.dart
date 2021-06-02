import 'package:flutter/material.dart';
import '../widgets/login/login_form.dart';

class LoginScreen extends StatelessWidget {
  static const url = "/login";

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: LoginForm(),
      ),
    );
  }
}
