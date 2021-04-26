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
            .putFile(file)
            .then((v) async {
          value.update({"fileRef": v.ref.fullPath});
        });
      }
    });
  }

  Future<String> getDownloadUrl(
    String fileRef,
  ) async {
    final url = await FirebaseStorage.instance.ref(fileRef).getDownloadURL();
    return url;
  }

  Future<void> deleteHomework(
    DocumentSnapshot homework,
  ) async {
    CollectionReference ref = FirebaseFirestore.instance.collection("homework");
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
