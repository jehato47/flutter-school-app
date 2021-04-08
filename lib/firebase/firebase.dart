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
              await FirebaseFirestore.instance
                  .collection("attendance")
                  .doc("11-a")
                  .set({});
              CollectionReference ref = FirebaseFirestore.instance
                  .collection("attendance/11-c/pieces");

              // QuerySnapshot snapshot = await ref.;
              // print(snapshot.docs);
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
