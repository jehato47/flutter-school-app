import 'package:flutter/material.dart';
import '../helpers/envs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class NotificationP extends ChangeNotifier {
  final baseUrl = Envs.baseUrl;

  Future<List<dynamic>> getNotifications(String token) async {
    final headers = {
      "Authorization": "Token $token",
    };

    final response = await http.get(
      Uri.parse(baseUrl + "/general/getnot/11-a"),
      headers: headers,
    );
    final liste = utf8.decode(response.bodyBytes);
    final normalJson = json.decode(liste);
    print(normalJson);
    return normalJson;
  }

  Future<void> addNotification(
    String creator,
    String content,
    File file,
  ) async {
    CollectionReference notifications =
        FirebaseFirestore.instance.collection('notification');
    String filename = file != null ? file.path.split("/").last : null;
    notifications.add({
      "creator": creator,
      "text": content,
      "isSeen": [],
      "added": DateTime.now(),
      "fileName": filename
    }).then((value) async {
      print("${value.id} 123123123");
      if (file != null) {
        await FirebaseStorage.instance
            .ref()
            .child(value.id)
            .child(file.path.split("/").last)
            .putFile(file);
        // e.g, e.code == 'canceled'
      }
    });
  }

  Future<void> deleteNotification(
    CollectionReference ref,
    DocumentSnapshot notification,
  ) async {
    ref.doc(notification.id).delete().then((value) async {
      if (notification["fileName"] != null) {
        await FirebaseStorage.instance
            .ref()
            .child(notification.id)
            .child(notification["fileName"])
            .delete();
      }
    });
  }

  Future<void> uploadFile(File file) async {
    await FirebaseStorage.instance
        .ref()
        .child(file.path.split("/").last)
        .putFile(file);
    // e.g, e.code == 'canceled'
  }

  Future<String> getDownloadUrl(
    DocumentSnapshot notification,
  ) async {
    return FirebaseStorage.instance
        .ref()
        .child(notification.id)
        .child(notification["fileName"])
        .getDownloadURL();

    //   Directory appDocDir = await getApplicationDocumentsDirectory();
    //   final status = await Permission.storage.request();
    //   if (!status.isGranted) return;
    //   File downloadToFile = File("/storage/emulated/0/Download/$name");
    //   print(name);
    //   if (name != null)
    //     await FirebaseStorage.instance
    //         .ref('$id/$name')
    //         .writeToFile(downloadToFile);
    //   // e.g, e.code == 'canceled'
  }
}
