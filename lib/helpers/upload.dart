import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

class Upload extends ChangeNotifier {
  var folderName = "folder";
  FirebaseAuth auth = FirebaseAuth.instance;
  Future<void> uploadFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null && kIsWeb) {
      for (var file in result.files) {
        dynamic fileBytes = file.bytes;
        String fileName = file.name;
        print(fileName);

        await FirebaseStorage.instance
            .ref('${auth.currentUser!.uid}/$folderName/$fileName')
            .putData(fileBytes)
            .then((snapshot) async {
          final url = await snapshot.ref.getDownloadURL();
          await FirebaseFirestore.instance.collection("archive").add({
            "fileName": fileName,
            "uid": auth.currentUser!.uid,
            "displayName": auth.currentUser!.displayName,
            "folderName": folderName,
            "fileRef": snapshot.ref.fullPath,
            "url": url,
          });
          print(snapshot.ref);
        });
      }
    } else if (result != null && !kIsWeb) {
      // List<File> files = result.paths.map((path) => File(path)).toList();
      List<File> files = result.paths.map((path) => File(path!)).toList();

      for (var file in files) {
        String fileName = file.path.split("/").last;
        await FirebaseStorage.instance
            .ref('${auth.currentUser!.uid}/$folderName/$fileName')
            .putFile(file)
            .then((snapshot) async {
          final url = await snapshot.ref.getDownloadURL();
          await FirebaseFirestore.instance.collection("archive").add({
            "date": DateTime.now(),
            "fileName": fileName,
            "uid": auth.currentUser!.uid,
            "displayName": auth.currentUser!.displayName,
            "folderName": folderName,
            "fileRef": snapshot.ref.fullPath,
            "url": url,
          });
        });
      }
    } else {}
  }
}
