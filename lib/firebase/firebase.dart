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
                FirebaseAuth auth = FirebaseAuth.instance;
                QuerySnapshot snapshot = await FirebaseFirestore.instance
                    .collection("user")
                    .where("role", isEqualTo: "teacher")
                    .get();

                for (var teacher in snapshot.docs) {
                  await FirebaseFirestore.instance
                      .collection("etudeTimes")
                      .doc(teacher.id)
                      .set({
                    "displayName": teacher["displayName"],
                    "lecture": teacher["lecture"],
                    "ref": teacher.reference,
                    "monday": {},
                    "tuesday": {},
                    "wednesday": {},
                    "thursday": {},
                    "friday": {},
                    "saturday": {},
                    "sunday": {},
                  });
                }
                // // DocumentSnapshot snapshot = await FirebaseFirestore.instance
                // //     .collection("syllabus")
                // //     .doc("auth.currentUser.uid")
                // //     .get();

                // // print(snapshot.data() == null);

                // QuerySnapshot snapshot = await FirebaseFirestore.instance
                //     .collection("user")
                //     .where("role", isEqualTo: "teacher")
                //     .get();

                // for (var teacher in snapshot.docs) {
                //   FirebaseFirestore.instance
                //       .collection("syllabus")
                //       .doc(teacher.id)
                //       .set({
                //     // "uid": teacher.id,
                //     // "lecture": teacher["lecture"],
                //     // "displayName": teacher["displayName"],
                //     "monday": {
                //       "11-c": DateTime(2021, 11, 3, 11, 30),
                //     },
                //     "tuesday": {
                //       "11-g": DateTime(2021, 11, 3, 12, 30),
                //       "11-d": DateTime(2021, 11, 3, 14, 30),
                //       "11-c": DateTime(2021, 11, 3, 16, 35),
                //     },
                //     "wednesday": {
                //       "11-d": DateTime(2021, 11, 3, 13, 40),
                //     },
                //     "thursday": {
                //       "11-f": DateTime(2021, 11, 3, 5, 30),
                //     },
                //     "friday": {
                //       "11-d": DateTime(2021, 11, 3, 15, 30),
                //       "11-c": DateTime(2021, 11, 3, 11, 30),
                //       "11-g": DateTime(2021, 11, 3, 10, 30),
                //     },
                //     "saturday": {
                //       "11-c": DateTime(2021, 11, 3, 11, 30),
                //     },
                //     "sunday": {
                //       "11-g": DateTime(2021, 11, 3, 11, 30),
                //     },
                //   });
                // }

                // FirebaseAuth auth = FirebaseAuth.instance;
                // // auth.signInWithCustomToken();
                // QuerySnapshot snapshot = await FirebaseFirestore.instance
                //     .collection("teacher")
                //     .get();

                // List<QueryDocumentSnapshot> items = snapshot.docs;

                // for (var item in items) {
                //   await FirebaseAuth.instance.signInWithEmailAndPassword(
                //       email: item["email"], password: "123465789");
                //   await FirebaseAuth.instance.currentUser.delete();
                //   await Provider.of<Auth>(context).signTeacherUp(
                //     item["email"],
                //     item["password"],
                //     item["name"],
                //     item["surname"],
                //     item["phoneNumber"],
                //     item["lecture"],
                //     null,
                //   );
                // }

                // await Provider.of<Auth>(context).signTeacherUp(
                //   "mcanakay@hotmail.com",
                //   "123465789",
                //   "Mehmetcan",
                //   "Akay",
                //   "05366639292",
                //   "fizik",
                //   null,
                // );

                return;
              },
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection("etude").snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(child: CircularProgressIndicator());
                List<QueryDocumentSnapshot> docs = snapshot.data.docs;

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () async {
                        print(docs[index].id);
                        // return;
                        await FirebaseFirestore.instance
                            .collection("etude")
                            .doc(docs[index].id)
                            .update({
                          "notParticipate": [1, 2, 3, 4]
                        });
                      },
                      title: Text(
                        docs[index]["lecture"],
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
