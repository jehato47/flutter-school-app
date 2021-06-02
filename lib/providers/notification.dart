import 'package:flutter/material.dart';
import '../helpers/envs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

class NotificationP extends ChangeNotifier {
  final baseUrl = Envs.baseUrl;

  Future<void> addNotification(
    String creator,
    String content,
    dynamic file,
    String fileName,
    String to,
  ) async {
    CollectionReference notifications =
        FirebaseFirestore.instance.collection('notification');

    if (kIsWeb) {
      notifications.add({
        "to": to,
        "creator": creator,
        "text": content,
        "isSeen": [],
        "added": DateTime.now(),
        "fileName": fileName
      }).then((value) async {
        if (file != null) {
          await FirebaseStorage.instance
              .ref()
              .child("notification")
              .child(value.id)
              .child(fileName)
              // Different part from bottom is putData
              // Because in web it brings files as bytes
              .putData(file);
        }
      });
    } else {
      notifications.add({
        "to": to,
        "creator": creator,
        "text": content,
        "isSeen": [],
        "added": DateTime.now(),
        "fileName": fileName
      }).then((value) async {
        if (file != null) {
          await FirebaseStorage.instance
              .ref()
              .child("notification")
              .child(value.id)
              .child(file.path.split("/").last)
              .putFile(file);
        }
      });
    }
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
