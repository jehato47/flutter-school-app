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
import 'package:flutter_card_swipper/flutter_card_swiper.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

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
        children: [
          TextFormField(
            // controller: hwController,
            validator: (value) {
              if (value.isEmpty) return "Ödev girmediniz";
              return null;
            },
            onSaved: (newValue) {
              // hw["homework"] = newValue;
            },
            decoration: InputDecoration(
              labelText: "Ödev",
              // border: OutlineInputBorder(),
            ),
          ),
          TextFormField(
            minLines: 2,
            maxLines: 5,
            validator: (value) {
              if (value.isEmpty) return "Açıklama girmediniz";
              return null;
            },
            onSaved: (newValue) {
              // hw["explanation"] = newValue;
            },
            decoration: InputDecoration(
              labelText: "Açıklama",
              alignLabelWithHint: true,
              // border: OutlineInputBorder(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (context, index) => Chip(
                label: Text("qwe"),
              ),
            ),
          )
          // ListTile(
          //   // leading: Container(),
          //   // contentPadding: ,
          //   leading: Text(""),
          //   title: TextField(
          //     decoration: new InputDecoration(
          //       border: InputBorder.none,
          //       focusedBorder: InputBorder.none,
          //       enabledBorder: InputBorder.none,
          //       errorBorder: InputBorder.none,
          //       disabledBorder: InputBorder.none,
          //       contentPadding:
          //           EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
          //       hintText: "Ödev Başlık",
          //     ),
          //     style: TextStyle(fontSize: 20),
          //   ),
          // ),
          // Divider(),
          // ListTile(
          //   leading: Icon(Icons.alarm),
          //   title: Text("weq"),
          // ),
        ],
      ),
    );
  }

  Widget centerButton() {
    return Center(
      child: ElevatedButton(
        child: Text("send"),
        onPressed: () async {
          print(122);

          final response =
              await FirebaseFirestore.instance.collection("slides").get();
          print(response.docs);
          List<QueryDocumentSnapshot> docs3 = response.docs;

          for (var e in docs3) {
            print(e.data());

            await FirebaseFirestore.instance
                .collection("slides")
                .doc(e.id)
                .update({"date": DateTime.now()});
          }
          return;
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
          QuerySnapshot snapshot = await FirebaseFirestore.instance
              .collection("etudeTimes")
              .where("lecture", isEqualTo: "matematik")
              .get();

          List<QueryDocumentSnapshot> docs = snapshot.docs;

          for (int i = 0; i < 15; i++) {
            DateTime now = DateTime.now().add(Duration(days: i));
            Intl.defaultLocale = "en_EN";
            String day = DateFormat("EEEE").format(now).toLowerCase();
            Intl.defaultLocale = "tr_TR";

            docs.forEach((doc) async {
              dynamic etudesofday = doc.data()[day];
              if (!doc.data().containsKey(day)) return;

              await etudesofday.forEach((e) async {
                DateTime oldDate = e.toDate();

                DateTime newTime = DateTime(
                  now.year,
                  now.month,
                  now.day,
                  oldDate.hour,
                  oldDate.minute,
                );
                // print("$day $newTime");
                QuerySnapshot dSnapshot = await FirebaseFirestore.instance
                    .collection("etude")
                    .where("uid", isEqualTo: doc.id)
                    .where("date", isEqualTo: newTime)
                    .get();

                if (dSnapshot.docs.isEmpty)
                  await FirebaseFirestore.instance.collection("etude")
                      // .doc(newTime.toString())
                      .add({
                    "date": newTime,
                    "lecture": doc["lecture"],
                    "notParticipate": [],
                    "registered": [],
                    "requests": [],
                    "subject": "Düzgün Doğrusal Hareket",
                    "teacherName": doc["displayName"],
                    "uid": doc.id,
                  });
                else if (dSnapshot.docs.length == 1)
                  await FirebaseFirestore.instance
                      .collection("etude")
                      // .doc(newTime.toString())
                      .doc(dSnapshot.docs[0].id)
                      .update({
                    "date": newTime,
                    "lecture": doc["lecture"],
                    "notParticipate": [],
                    "registered": [1, 1, 3, 2],
                    "subject": "Düzgün Doğrusal Hareket",
                    "teacherName": doc["displayName"],
                    "uid": doc.id,
                  });
              });
            });
          }
          return;
        },
      ),
    );
  }
}
