import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class HomeWork extends ChangeNotifier {
  Future<void> addHomeWork(
    dynamic homework,
    dynamic file,
  ) async {
    // print(homework);
    homework["startDate"] = DateTime.now();
    homework["isSeen"] = [];
    // TODO : BAK
    late String ref;

    CollectionReference homeworks =
        FirebaseFirestore.instance.collection('homework');

    DocumentReference docRef =
        await FirebaseFirestore.instance.collection("timetable").add({
      // "subject": "Ödev",
      "date": homework["dueDate"],
      "uids": [homework["to"]],
      "isRecursive": false,
      "subject": "${homework["lecture"]} ödev - ${homework["homework"]}",
      "note": "",
    });
    homework["timetableRef"] = docRef.path;

    if (kIsWeb) {
      await homeworks.add(homework).then((value) async {
        ref = value.path;
        if (file != null) {
          await FirebaseStorage.instance
              .ref()
              .child("homework")
              .child(value.id)
              .child(homework["fileName"])
              .putData(file)
              .then((v) async {
            value.update({"fileRef": v.ref.fullPath});
          });
        }
      });
    } else {
      await homeworks.add(homework).then((value) async {
        ref = value.path;
        if (file != null) {
          await FirebaseStorage.instance
              .ref()
              .child("homework")
              .child(value.id)
              .child(homework["fileName"])
              .putFile(file)
              .then((v) async {
            value.update({"fileRef": v.ref.fullPath});
          });
        }
      });
    }
    await docRef.update({"note": ref});
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
    await FirebaseFirestore.instance.doc(homework["timetableRef"]).delete();
  }
}
