import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
// import 'package:school2/screens/home_screen.dart';
import '../../screens/home/teacher_home_screen.dart';
// import 'dashboard_screen.dart';
import '../../providers/auth.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

const users = const {
  'dribbble@gmail.com': '12345',
  'hunter@gmail.com': 'hunter',
};

class LoginScreen2 extends StatelessWidget {
  static const url = "login-2";
  Duration get loginTime => Duration(milliseconds: 2250);
  Future<dynamic> login(BuildContext context, LoginData data) async {
    // return null;
    final result = await Provider.of<Auth>(context, listen: false)
        .login(data.name, data.password);

    return result;
  }

  Future<dynamic> signUp(BuildContext context, LoginData data) async {
    // return null;
    // final result = await Provider.of<Auth>(context, listen: false)
    //     .singUp(data.name, data.password);
    String result = "no result";
    return result;
  }

  // Future<String> _authUser(LoginData data) {
  //   print('Name: ${data.name}, Password: ${data.password}');
  //   return Future.delayed(loginTime).then((_) {
  //     if (!users.containsKey(data.name)) {
  //       return 'Username not exists';
  //     }
  //     if (users[data.name] != data.password) {
  //       return 'Password does not match';
  //     }
  //     return null;
  //   });
  // }

  Future<String> _recoverPassword(String name) {
    print('Name: $name');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(name)) {
        return 'Username not exists';
      }
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      messages: LoginMessages(
        userHint: "Kullanıcı Adı",
        passwordHint: "Şifre",
        flushbarTitleError: "Hata",
        loginButton: "Giriş Yap",
        signupButton: "Kayıt Ol",
      ),
      title: 'SJ',
      hideSignUpButton: true,
      // logo: 'assets/images/ecorp-lightblue.png',
      hideForgotPasswordButton: true,
      onLogin: (LoginData data) async {
        final response = await login(context, data);
        return response;
      },
      onSignup: (LoginData data) async {
        final response = await signUp(context, data);
        return response;
      },
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => TeacherHomeScreen(),
        ));
      },
      onRecoverPassword: _recoverPassword,
    );
  }
}
