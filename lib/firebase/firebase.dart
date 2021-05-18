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
  Future<void> pickFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      file = File(result.files.single.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(
              child: Text("send"),
              onPressed: () async {
                // var list =
                //     new List<String>.generate(2, (i) => (i + 1).toString());

                FirebaseAuth auth = FirebaseAuth.instance;
                // Provider.of<Auth>(context).signStudentUp(
                //   "ilysumt@hotmail.com",
                //   "123465789",
                //   "ilyasumut",
                //   "İlyas Umut",
                //   "Apul",
                //   159,
                //   "11",
                //   "g",
                //   "05366639292",
                //   file,
                // );
                // Provider.of<Auth>(context).signTeacherUp(
                //   "pkcnaksz@hotmail.com",
                //   "123465789",
                //   "Pekcan",
                //   "Aksöz",
                //   "05366639292",
                //   "matematik",
                //   file,
                // );
                // CollectionReference ref =
                //     FirebaseFirestore.instance.collection("students");
                // CollectionReference ref2 =
                //     FirebaseFirestore.instance.collection("exam");

                // QuerySnapshot snapshot = await ref.get();
                // print(snapshot.docs[0].id);

                // snapshot.docs.forEach((element) async {
                //   await ref2.doc(element.id).set({
                //     "displayName": element["displayName"],
                //     "number": element["number"],
                //     "classFirst": element["classFirst"],
                //     "classLast": element["classLast"],
                //     "matematik": {
                //       "1": null,
                //       "2": null,
                //       "3": null,
                //     },
                //     "fizik": {
                //       "1": null,
                //       "2": null,
                //     },
                //     "kimya": {
                //       "1": null,
                //       "2": null,
                //     },
                //     "biyoloji": {
                //       "1": null,
                //       "2": null,
                //     },
                //     "türkçe": {
                //       "1": null,
                //       "2": null,
                //       "3": null,
                //     },
                //     "sosyalbilgiler": {
                //       "1": null,
                //       "2": null,
                //     },
                //     "coğrafya": {
                //       "1": null,
                //       "2": null,
                //     },
                //     "dilbilgisi": {
                //       "1": null,
                //       "2": null,
                //     },
                //   });
                // });

                CollectionReference teacherRef =
                    FirebaseFirestore.instance.collection("teacher");
                final teachers = await teacherRef.get();

                print(teachers.docs[0]["displayName"]);

                CollectionReference ref =
                    FirebaseFirestore.instance.collection("etudeTimes");

                await ref.doc(teachers.docs[0].id).set({
                  "ref": teachers.docs[0].reference,
                  "lecture": teachers.docs[0]["lecture"],
                  "displayName": teachers.docs[0]["displayName"],
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
                    .collection("etude/${teachers.docs[0].id}/pieces")
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
                  "uid": teachers.docs[0].id,
                  "lecture": teachers.docs[0]["lecture"]
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
