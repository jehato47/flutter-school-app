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
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ElevatedButton(
            //   child: Text("send"),
            //   onPressed: () async {},
            // ),

            // Card(
            //   child: Container(
            //     decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(10),
            //       color: Color.fromRGBO(255, 235, 228, 1),
            //     ),
            //     // margin: EdgeInsets.all(20),
            //     padding: EdgeInsets.all(20),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Text(
            //           "Football",
            //           style:
            //               TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            //         ),
            //         SizedBox(height: 10),
            //         Text(
            //           "Ligue 1 opener postponed after marseille virus cases",
            //           style: TextStyle(
            //               // fontWeight: FontWeight.w300,
            //               color: Colors.black45),
            //         ),
            //         SizedBox(height: 10),
            //         Row(
            //           children: [
            //             Icon(
            //               Icons.location_on_rounded,
            //               color: Colors.blue,
            //             ),
            //             Text(
            //               "Marlowe",
            //               style: TextStyle(color: Colors.blue),
            //             ),
            //           ],
            //         ),
            //         Divider(),
            //         Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //           children: [
            //             Row(
            //               children: [
            //                 Icon(Icons.schedule),
            //                 SizedBox(width: 10),
            //                 Text(
            //                   "4:30 PM - 5:45 PM",
            //                 ),
            //               ],
            //             ),
            //             Row(
            //               children: [
            //                 CircleAvatar(
            //                   backgroundImage: NetworkImage(
            //                       "https://images.pexels.com/photos/6619945/pexels-photo-6619945.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"),
            //                 ),
            //                 CircleAvatar(
            //                   backgroundImage: NetworkImage(
            //                       "https://images.pexels.com/photos/6619945/pexels-photo-6619945.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"),
            //                 ),
            //               ],
            //             )
            //           ],
            //         )
            //       ],
            //     ),
            //   ),
            // ),

            // ListTile
          ],
        ),
      ),
    );
  }
}
