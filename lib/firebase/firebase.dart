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

class FireBaseTryScreen extends StatefulWidget {
  @override
  _FireBaseTryScreenState createState() => _FireBaseTryScreenState();
}

class _FireBaseTryScreenState extends State<FireBaseTryScreen> {
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
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            child: Text("send"),
            onPressed: () async {
              // FirebaseAuth auth = FirebaseAuth.instance;
              // Provider.of<Auth>(context).signTeacherUp(
              //   "jehat2223@hotmail.com",
              //   "123465789",
              //   "hacı",
              //   "ekram",
              //   "05366639292",
              //   "biyoloji",
              //   "https://firebasestorage.googleapis.com/v0/b/school-f162e.appspot.com/o/default.jpg?alt=media&token=98ab15cf-2ea9-43db-a725-970650e5df5f",
              // );

              CollectionReference teacherRef =
                  FirebaseFirestore.instance.collection("teacher");
              final teachers = await teacherRef.get();

              print(teachers.docs[1]["displayName"]);

              CollectionReference ref =
                  FirebaseFirestore.instance.collection("etudeTimes");

              await ref.doc(teachers.docs[1].id).set({
                "ref": teachers.docs[1].reference,
                "lecture": teachers.docs[1]["lecture"],
                "displayName": teachers.docs[1]["displayName"],
                "monday": [
                  DateTime(2021, 4, 26, 14, 30),
                ],
                "tuesday": [
                  DateTime(2021, 4, 26, 14, 30),
                ],
                "wednesday": [
                  DateTime(2021, 4, 26, 14, 30),
                ],
                "thursday": [
                  DateTime(2021, 4, 26, 14, 30),
                ],
              });

              final data = await ref.get();

              print(data.docs);

              // QuerySnapshot querySnapshot = await
              FirebaseFirestore.instance
                  .collection("etude/${teachers.docs[1].id}/pieces")
                  //     .get();

                  // print(querySnapshot.docs[0].data());
                  .doc(DateTime(2021, 5, 26, 14, 30).toString())
                  .set({
                "date": DateTime(2021, 5, 26, 14, 30),
                "notParticipate": [],
                "registered": [],
                "requests": [],
                "subject": "",
                "teacherName": "",
                "uid": teachers.docs[1].id,
                "lecture": teachers.docs[1]["lecture"]
              });
            },
          ),
          SizedBox(
            width: double.infinity,
            child: Container(),
          ),
        ],
      ),
    );
  }
}
