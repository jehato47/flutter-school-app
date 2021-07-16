import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:school2/providers/attendance.dart';
import 'package:school2/widgets/homework/homework_form.dart';
import '../providers/auth.dart';
import './item.dart';
import 'dart:math';
import '../screens/attendance/attendance_detail_screen.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:flutter_card_swipper/flutter_card_swiper.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class Item {
  final DateTime startTime;
  final DateTime endTime;
  final bool isRecurrent;
  final dynamic color;
  final String subject;

  Item(
    this.startTime,
    this.endTime,
    this.isRecurrent,
    this.color,
    this.subject,
  );
}

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

  Map<String, dynamic> chipList = {
    "Önemli": Colors.red,
    "Yapmasanız da olur": Colors.amber
  };
  Map<String, dynamic> newList = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: HomeworkForm(),
          ),
          // Expanded(
          //   child: StreamBuilder(
          //     stream: FirebaseFirestore.instance
          //         .collection("timetable")
          //         .where("uids", arrayContainsAny: ["11-a"])
          //         // .where("note", isEqualTo: "homework")
          //         .orderBy("date", descending: true)
          //         .snapshots(),
          //     builder: (context, snapshot) {
          //       if (snapshot.data == null) {
          //         return Center(child: CircularProgressIndicator());
          //       }
          //       final data = snapshot.data;
          //       // print(data.docs);
          //       List<QueryDocumentSnapshot> docs = data.docs;
          //       return ListView.builder(
          //         itemCount: docs.length,
          //         itemBuilder: (context, index) => ListTile(
          //           title: Text(docs[index]["subject"]),
          //         ),
          //       );
          //     },
          //   ),
          // )
          // centerButton()
          // Expanded(
          //   child: ListView.builder(
          //     itemCount: chipList.length,
          //     itemBuilder: (context, index) {
          //       String key = chipList.keys.elementAt(index);
          //       return Chip(
          //         label: Text(key),
          //         backgroundColor: chipList[key],
          //         deleteIcon: Icon(Icons.add),
          //         onDeleted: () {
          //           setState(() {
          //             // print(key);
          //             if (!newList.keys.contains(key)) {
          //               setState(() {
          //                 newList[key] = chipList[key];
          //                 chipList.removeWhere((tag, value) => tag == key);
          //               });
          //               // print(key);
          //               print(newList);
          //               print(chipList);
          //               // newList.add(chipList[index]);
          //               // newList[chipList]
          //               // chipList
          //               //     .removeWhere((element) => element == chipList[index]);
          //             }
          //           });
          //         },
          //       );
          //     },
          //   ),
          // ),
          // Expanded(
          //   child: ListView.builder(
          //     scrollDirection: Axis.horizontal,
          //     itemCount: newList.length,
          //     itemBuilder: (context, index) {
          //       String key = newList.keys.elementAt(index);
          //       return Chip(
          //         label: Text(key),
          //         backgroundColor: newList[key],
          //         deleteIcon: Icon(Icons.add),
          //         onDeleted: () {
          //           setState(() {
          //             // print()

          //             chipList[key] = newList[key];
          //             newList.removeWhere((tag, value) => tag == key);

          //             // print(newList[key]);
          //           });
          //         },
          //       );
          //     },
          //   ),
          // )

          // centerButton(),
        ],
      ),
    );
  }

  Widget centerButton() {
    return Center(
      child: ElevatedButton(
        child: Text("send"),
        onPressed: () async {
          Map<String, dynamic> days = {
            "monday": DateTime(2020, 1, 6),
            "tuesday": DateTime(2020, 1, 7),
            "wednesday": DateTime(2020, 1, 8),
            "thursday": DateTime(2020, 1, 9),
            "friday": DateTime(2020, 1, 10),
            "saturday": DateTime(2020, 1, 11),
            "sunday": DateTime(2020, 1, 12),
          };
          final response =
              await FirebaseFirestore.instance.collection("syllabus").get();

          List<QueryDocumentSnapshot> docs = response.docs;

          for (var e in docs) {
            // print(12);
            // FirebaseFirestore.instance.collection("timetable").add(data)
            dynamic teacherData = e.data();
            await teacherData.forEach((day, value) async {
              await value.forEach((clss, timestamp) async {
                DateTime date = timestamp.toDate();
                print(clss);
                // print(date.hour);
                // return;
                await FirebaseFirestore.instance.collection("timetable").add({
                  "uids": [e.id],
                  "subject": clss,
                  "date": days[day]
                      .add(Duration(hours: date.hour, minutes: date.minute)),
                  "isRecursive": true,
                  "note": "teachertimetable",
                });
              });
            });
          }

          return;

          // print(122);

          // final response =
          //     await FirebaseFirestore.instance.collection("slides").get();
          // print(response.docs);
          // List<QueryDocumentSnapshot> docs3 = response.docs;

          // for (var e in docs3) {
          //   print(e.data());

          //   await FirebaseFirestore.instance
          //       .collection("slides")
          //       .doc(e.id)
          //       .update({"date": DateTime.now()});
          // }
          // return;
          // List<String> liste = [];
          // QuerySnapshot snapshot = await FirebaseFirestore.instance
          //     .collection("syllabus")
          //     .get();

          // for (var element in snapshot.docs) {
          //   dynamic data = element.data();

          //   data.forEach((e, j) {
          //     dynamic data2 = j;
          //     data2.forEach((k, l) {
          //       liste.add(k);
          //       // print(k);
          //     });
          //   });

          //   await FirebaseFirestore.instance
          //       .collection("user")
          //       .doc(element.id)
          //       .update({"classes": liste.toSet().toList()});
          // }

          // // print(liste.toSet().toList());

          // return;

          // await Provider.of<Auth>(context).signStudentUp(
          //     "pksyats@hotmail.com",
          //     "123465789",
          //     "pksyats",
          //     "Paksoy",
          //     "Ateş",
          //     152,
          //     "11",
          //     "c",
          //     "05366639292",
          //     null);
          // return;
          // FirebaseAuth auth = FirebaseAuth.instance;
          // QuerySnapshot snapshot2 = await FirebaseFirestore.instance
          //     .collection("etude/TXWUtv8s9bZnMfGZNpkrJLDKRmE3/pieces")
          //     .where(
          //       "date",
          //       isGreaterThanOrEqualTo: DateTime.now(),
          //     )
          //     .get();
          // List<QueryDocumentSnapshot> docs2 = snapshot2.docs;
          // print(docs2);

          // return;
          // QuerySnapshot snapshot = await FirebaseFirestore.instance
          //     .collection("etudeTimes")
          //     .where("lecture", isEqualTo: "matematik")
          //     .get();

          // List<QueryDocumentSnapshot> docs = snapshot.docs;

          // for (int i = 0; i < 15; i++) {
          //   DateTime now = DateTime.now().add(Duration(days: i));
          //   Intl.defaultLocale = "en_EN";
          //   String day = DateFormat("EEEE").format(now).toLowerCase();
          //   Intl.defaultLocale = "tr_TR";

          //   docs.forEach((doc) async {
          //     dynamic etudesofday = doc.data()[day];
          //     if (!doc.data().containsKey(day)) return;

          //     await etudesofday.forEach((e) async {
          //       DateTime oldDate = e.toDate();

          //       DateTime newTime = DateTime(
          //         now.year,
          //         now.month,
          //         now.day,
          //         oldDate.hour,
          //         oldDate.minute,
          //       );
          //       // print("$day $newTime");
          //       QuerySnapshot dSnapshot = await FirebaseFirestore.instance
          //           .collection("etude")
          //           .where("uid", isEqualTo: doc.id)
          //           .where("date", isEqualTo: newTime)
          //           .get();

          //       if (dSnapshot.docs.isEmpty)
          //         await FirebaseFirestore.instance.collection("etude")
          //             // .doc(newTime.toString())
          //             .add({
          //           "date": newTime,
          //           "lecture": doc["lecture"],
          //           "notParticipate": [],
          //           "registered": [],
          //           "requests": [],
          //           "subject": "Düzgün Doğrusal Hareket",
          //           "teacherName": doc["displayName"],
          //           "uid": doc.id,
          //         });
          //       else if (dSnapshot.docs.length == 1)
          //         await FirebaseFirestore.instance
          //             .collection("etude")
          //             // .doc(newTime.toString())
          //             .doc(dSnapshot.docs[0].id)
          //             .update({
          //           "date": newTime,
          //           "lecture": doc["lecture"],
          //           "notParticipate": [],
          //           "registered": [1, 1, 3, 2],
          //           "subject": "Düzgün Doğrusal Hareket",
          //           "teacherName": doc["displayName"],
          //           "uid": doc.id,
          //         });
          //     });
          //   });
          // }
          // return;
        },
      ),
    );
  }
}
