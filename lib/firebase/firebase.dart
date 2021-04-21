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
              FirebaseAuth auth = FirebaseAuth.instance;
              // await Provider.of<Auth>(context).signStudentUp(
              //   "akcagrkcagc@hotmail.com",
              //   "123465789",
              //   "jehato231",
              //   "Emine Münevver",
              //   "Akcaağırkocaağaç",
              //   2023,
              //   "11",
              //   "c",
              //   "05366639292",
              //   "https://firebasestorage.googleapis.com/v0/b/school-f162e.appspot.com/o/default.jpg?alt=media&token=98ab15cf-2ea9-43db-a725-970650e5df5f",
              // );
              Query query = FirebaseFirestore.instance
                  .collection("homework")
                  .where("uid", isEqualTo: auth.currentUser.uid);

              final docs = await query.get();
              print(docs.docs[0]["homework"]);
              // final docs = await ref.get();
              // print(docs.docs[0].id);
// FirebaseFirestore.instance.collection("homework").where("field")
              // CollectionReference ref2 =
              //     FirebaseFirestore.instance.collection("exam");
              // docs.docs.forEach((element) {
              //   ref2.doc(element.id).set({
              //     "number": element["number"],
              //     "displayName": element["displayName"],
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
              //     "biyoloji": {
              //       "1": null,
              //       "2": null,
              //     },
              //     "kimya": {
              //       "1": null,
              //       "2": null,
              //     },
              //     "türkçe": {
              //       "1": null,
              //       "2": null,
              //       "3": null,
              //     },
              //     "coğrafya": {
              //       "1": null,
              //       "2": null,
              //     },
              //     "sosyalbilgiler": {
              //       "1": null,
              //       "2": null,
              //     },
              //     "dilbilgisi": {
              //       "1": null,
              //       "2": null,
              //     }
              //   });
              // });
            },
          ),
          SizedBox(
            width: double.infinity,
            child: Container(),
          ),
          // StreamBuilder(
          //   stream: FirebaseFirestore.instance
          //       .collection("exam")
          //       .doc("07vrUvDetmXAOU1zzWq3JBCKcds2")
          //       .snapshots(),
          //   builder: (context, snapshot) {
          //     if (snapshot.connectionState == ConnectionState.waiting)
          //       return Center(
          //         child: CircularProgressIndicator(),
          //       );

          //     return Expanded(
          //       child: ListView(
          //         children: [
          //           ListTile(
          //             title: Text(snapshot.data["matematik"].toString()),
          //           )
          //         ],
          //       ),
          //     );
          //   },
          // )
        ],
      ),
    );
  }
}
