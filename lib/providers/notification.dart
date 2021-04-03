import 'package:flutter/material.dart';
import '../helpers/envs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class NotificationP extends ChangeNotifier {
  final baseUrl = Envs.baseUrl;

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
      if (file != null) {
        await FirebaseStorage.instance
            .ref()
            .child("notification")
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
            .child("notification")
            .child(notification.id)
            .child(notification["fileName"])
            .delete();
      }
    });
  }

  Future<String> getDownloadUrl(
    DocumentSnapshot notification,
  ) async {
    return FirebaseStorage.instance
        .ref()
        .child("notification")
        .child(notification.id)
        .child(notification["fileName"])
        .getDownloadURL();
  }
}
