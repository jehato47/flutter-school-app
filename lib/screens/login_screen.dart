import 'package:flutter/material.dart';
import '../widgets/login/login_form.dart';

class LoginScreen extends StatelessWidget {
  static const url = "/login";

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(
            "https://cdn.dribbble.com/users/1973964/screenshots/8807446/media/23e0807883cb7dfd409d049b584a642b.jpg?compress=1&resize=1000x750",
          ),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: LoginForm(),
      ),
    );
  }
}
