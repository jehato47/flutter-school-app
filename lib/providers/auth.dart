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
    File file,
  ) async {
    String photoUrl =
        "https://firebasestorage.googleapis.com/v0/b/school-f162e.appspot.com/o/default.jpg?alt=media&token=98ab15cf-2ea9-43db-a725-970650e5df5f";

    UserCredential userCredential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    CollectionReference students =
        FirebaseFirestore.instance.collection('students');

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
        "https://firebasestorage.googleapis.com/v0/b/school-f162e.appspot.com/o/default.jpg?alt=media&token=98ab15cf-2ea9-43db-a725-970650e5df5f";
    UserCredential userCredential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    CollectionReference teachers =
        FirebaseFirestore.instance.collection('teacher');
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

  Future<void> login(String username, String password) async {
    try {
      await auth.signInWithEmailAndPassword(
        email: username,
        password: password,
      );
      return null;
    } catch (err) {
      return err.toString();
    }
  }

  Future<void> logout() async {}

  Future<void> getInfoByToken() async {}

  Future<dynamic> getStudentByNumber(int number) async {}
}
