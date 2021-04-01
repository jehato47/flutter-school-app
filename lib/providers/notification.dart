import 'package:flutter/material.dart';
import '../helpers/envs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

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
        await firebase_storage.FirebaseStorage.instance
            .ref()
            .child(value.id)
            .child(file.path.split("/").last)
            .putFile(file);
        // e.g, e.code == 'canceled'
      }
    });
  }

  Future<void> uploadFile(File file) async {
    await firebase_storage.FirebaseStorage.instance
        .ref()
        .child(file.path.split("/").last)
        .putFile(file);
    // e.g, e.code == 'canceled'
  }

  Future<void> downloadFileExample(String id, String name) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    final status = await Permission.storage.request();
    if (!status.isGranted) return;
    File downloadToFile = File("/storage/emulated/0/Download/$name");
    print(name);
    if (name != null)
      await firebase_storage.FirebaseStorage.instance
          .ref('$id/$name')
          .writeToFile(downloadToFile);
    // e.g, e.code == 'canceled'
  }
}
