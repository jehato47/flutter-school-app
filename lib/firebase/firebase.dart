// import 'dart:html';
import '../providers/local_notification/local_notification.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:school2/providers/attendance.dart';
import '../providers/auth.dart';
import './item.dart';
import 'dart:math';
import '../screens/attendance/attendance_detail_screen.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart';
import 'package:url_launcher/url_launcher.dart';

class FireBaseTryScreen extends StatefulWidget {
  @override
  _FireBaseTryScreenState createState() => _FireBaseTryScreenState();
}

class _FireBaseTryScreenState extends State<FireBaseTryScreen> {
  File file;
  String classFirst;
  String classLast;
  CollectionReference attendance;
  List<String> days = [
    "monday",
    "tuesday",
    "wednesday",
    "thursday",
    "friday",
    "saturday",
    "sunday"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {},
          ),
        ],
        title: Text("Çilem Akçay"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            QuerySnapshot snapshot =
                await FirebaseFirestore.instance.collection("etudeTimes").get();
            Intl.defaultLocale = "en_EN";
            String today =
                DateFormat("EEEE").format(DateTime.now()).toLowerCase();
            Intl.defaultLocale = "tr_TR";

            final index = days.indexWhere((element) => element == today);

            print(snapshot.docs);
            print(index);
            for (int i = index; i < days.length; i++) {
              snapshot.docs.forEach((element) {
                if (element.data().containsKey(days[i])) {
                  print(days[i]);
                }
              });
            }
          },
          child: Text(
            "btn",
          ),
        ),
      ),
    );
  }
}
