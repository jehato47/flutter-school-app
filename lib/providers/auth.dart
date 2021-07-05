import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

class Auth extends ChangeNotifier {
  // -- Functions --
  // login
  // logout
  // getInfoByToken
  // getStudentByNumber
  FirebaseAuth auth = FirebaseAuth.instance;
  String _userToken;
  dynamic userInfo;

  get isAuth {
    return _userToken != null;
  }

  get token {
    if (isAuth) return _userToken;
    return null;
  }

  // get userInform {
  //   if (isAuth) {
  //     return userInfo;
  //   }
  //   return null;
  // }

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
    File file,
  ) async {
    String photoUrl =
        "https://firebasestorage.googleapis.com/v0/b/school-f162e.appspot.com/o/default.jpg?alt=media&token=516883de-679b-4624-90ef-72ecbd7b518d";

    UserCredential userCredential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    CollectionReference students =
        FirebaseFirestore.instance.collection('user');

    if (file != null)
      await FirebaseStorage.instance
          .ref()
          .child("profil_images")
          .child(userCredential.user.uid)
          .putFile(file)
          .then((response) async {
        photoUrl = await response.ref.getDownloadURL();
      });

    await students.doc(userCredential.user.uid).set({
      "role": "student",
      "email": userCredential.user.email,
      "photoUrl": photoUrl,
      "username": username,
      "name": name,
      "surname": surname,
      "number": studentNumber,
      "displayName": name + " " + surname,
      "classFirst": classFirst,
      "classLast": classLast,
      "parentNumber": parentNumber,
    });

    await userCredential.user.updateProfile(
      displayName: name + " " + surname,
      photoURL: photoUrl,
    );
    print(userCredential.user.displayName);
  }

  Future<void> signTeacherUp(
    String email,
    String password,
    String name,
    String surname,
    String phoneNumber,
    String lecture,
    File file,
  ) async {
    String photoUrl =
        "https://firebasestorage.googleapis.com/v0/b/school-f162e.appspot.com/o/default.jpg?alt=media&token=516883de-679b-4624-90ef-72ecbd7b518d";
    UserCredential userCredential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    CollectionReference teachers =
        FirebaseFirestore.instance.collection('user');
    if (file != null)
      await FirebaseStorage.instance
          .ref()
          .child("profil_images")
          .child(userCredential.user.uid)
          .putFile(file)
          .then((response) async {
        photoUrl = await response.ref.getDownloadURL();
      });

    await teachers.doc(userCredential.user.uid).set({
      "role": "teacher",
      "email": userCredential.user.email,
      "displayName": name + " " + surname,
      "lecture": lecture,
      "phoneNumber": phoneNumber,
      "signUpDate": DateTime.now(),
      "photoUrl": photoUrl,
    });

    await userCredential.user.updateProfile(
      displayName: name + " " + surname,
      photoURL: photoUrl,
    );

    print(userCredential.user.displayName);
  }

  Future<String> login(String username, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: username,
        password: password,
      );

      userInfo = await FirebaseFirestore.instance
          .collection("user")
          .doc(userCredential.user.uid)
          .get();

      print(122);
      return null;
    } catch (err) {
      if (err.code == "invalid-email")
        return "Hatalı mail formatı girdiniz.";
      else if (err.code == "wrong-password") return "Hatalı parola girdiniz.";

      print(err.code);
      return err.toString();
    }
  }

  Future<void> logout() async {}

  Future<void> getInfoByToken() async {}

  Future<dynamic> getStudentByNumber(int number) async {}
}
