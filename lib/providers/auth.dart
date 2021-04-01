import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../helpers/envs.dart';

class Auth extends ChangeNotifier {
  // -- Functions --
  // login
  // logout
  // getInfoByToken
  // getStudentByNumber

  String _baseUrl = Envs.baseUrl;
  String _userToken;
  Map<String, dynamic> _userInfo;

  get isAuth {
    return _userToken != null;
  }

  get token {
    if (isAuth) return _userToken;
    return null;
  }

  get userInform {
    if (isAuth) {
      return _userInfo;
    }
    return null;
  }

  Future<void> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl + "/user/loginuser"),
        body: json.encode(
          {
            "username": username,
            "password": password,
          },
        ),
        headers: {'Content-Type': 'application/json'},
      );
      _userToken = json.decode(response.body)["token"];
      if (_userToken == null) return;

      await getInfoByToken();
      // ******

      // ******

      if (response.statusCode == 200) notifyListeners();
    } catch (err) {}
  }

  Future<void> logout() async {
    await http.get(
      Uri.parse(_baseUrl + "/user/logoutuser"),
    );
    _userToken = null;
    notifyListeners();
  }

  Future<void> getInfoByToken() async {
    // Bu fonksiyonun loginin içinde kullandım
    var headers = {'Authorization': 'Token $_userToken'};

    final response = await http.get(
      Uri.parse(_baseUrl + "/user/getuserinfo"),
      headers: headers,
    );
    final liste = utf8.decode(response.bodyBytes);
    final normalJson = json.decode(liste);
    _userInfo = normalJson;
  }

  Future<dynamic> getStudentByNumber(int number) async {
    var headers = {'Authorization': 'Token $token'};
    final response = await http.get(
      Uri.parse(_baseUrl + "/student/student/$number"),
      headers: headers,
    );
    final normalResponse = utf8.decode(response.bodyBytes);
    final normalJson = json.decode(normalResponse);

    return normalJson;
  }
}
