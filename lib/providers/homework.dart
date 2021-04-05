import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class HomeWork extends ChangeNotifier {
  Future<void> addHomeWork(dynamic homework, File file) async {
    print(homework);
    homework["startDate"] = DateTime.now();
    homework["isSeen"] = [];

    CollectionReference homeworks =
        FirebaseFirestore.instance.collection('homework');

    await homeworks.add(homework).then((value) async {
      if (file != null) {
        await FirebaseStorage.instance
            .ref()
            .child("homework")
            .child(value.id)
            .child(file.path.split("/").last)
            .putFile(file);
      }
    });
  }

  Future<String> getDownloadUrl(
    DocumentSnapshot homework,
  ) async {
    return FirebaseStorage.instance
        .ref()
        .child("homework")
        .child(homework.id)
        .child(homework["fileName"])
        .getDownloadURL();
  }

  Future<void> deleteHomework(
    CollectionReference ref,
    DocumentSnapshot homework,
  ) async {
    ref.doc(homework.id).delete().then((value) async {
      if (homework["fileName"] != null) {
        try {
          await FirebaseStorage.instance
              .ref()
              .child("homework")
              .child(homework.id)
              .child(homework["fileName"])
              .delete();
        } catch (err) {
          print(err);
        }
      }
    });
  }
}
