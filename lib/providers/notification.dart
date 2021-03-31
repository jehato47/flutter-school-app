import 'package:flutter/material.dart';
import '../helpers/envs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationP extends ChangeNotifier {
  final baseUrl = Envs.baseUrl;

  Future<List<dynamic>> getNotifications(String token) async {
    final headers = {
      "Authorization": "Token $token",
    };

    final response = await http.get(
      baseUrl + "/general/getnot/11-a",
      headers: headers,
    );
    final liste = utf8.decode(response.bodyBytes);
    final normalJson = json.decode(liste);
    print(normalJson);
    return normalJson;
  }

  Future<void> addNotification(String creator, String content) async {
    CollectionReference notifications =
        FirebaseFirestore.instance.collection('notification');
    notifications.add({
      "oluşturan": creator,
      "text": content,
      "isSeen": true,
      "added": DateTime.now()
    }).then((value) {
      print(value);
    });
  }
}
