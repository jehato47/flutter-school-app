import 'package:flutter/material.dart';
import '../helpers/envs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Auth extends ChangeNotifier {
  // -- Functions --
  // login
  // logout
  // getInfoByToken
  // getStudentByNumber
  FirebaseAuth auth = FirebaseAuth.instance;
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

  Future<void> signStudentUp(
    String email,
    String password,
    String username,
    String name,
    String surname,
    int studentNumber,
    String classFirst,
    String classLast,
    String parentNumber,
    String photoUrl,
  ) async {
    UserCredential userCredential = await auth
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) async {
      CollectionReference students =
          FirebaseFirestore.instance.collection('students');
      students.doc(value.user.uid).set({
        "username": username,
        "name": name,
        "surname": surname,
        "number": studentNumber,
        "displayName": name + " " + surname,
        "classFirst": classFirst,
        "classLast": classLast,
        "parentNumber": parentNumber,
      });
      await value.user.updateProfile(
        displayName: name + " " + surname,
        photoURL: photoUrl,
      );
      return value;
    });
    print(userCredential.user.displayName);
  }

  Future<void> signTeacherUp(
    String email,
    String password,
    String name,
    String surname,
    String phoneNumber,
    String lecture,
    String photoUrl,
  ) async {
    UserCredential userCredential = await auth
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) async {
      CollectionReference students =
          FirebaseFirestore.instance.collection('teacher');
      students.doc(value.user.uid).set({
        "lecture": lecture,
        "phoneNumber": phoneNumber,
        "signUpDate": DateTime.now(),
      });
      await value.user.updateProfile(
        displayName: name + " " + surname,
        photoURL: photoUrl,
      );

      return value;
    });
    print(userCredential.user.displayName);
  }

  Future<void> login(String username, String password) async {
    try {
      final response = await auth.signInWithEmailAndPassword(
        email: username,
        password: password,
      );
      print(response.additionalUserInfo.username);
    } catch (err) {
      print(err);
    }
  }

  Future<void> logout() async {}

  Future<void> getInfoByToken() async {}

  Future<dynamic> getStudentByNumber(int number) async {}
}
