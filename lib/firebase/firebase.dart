import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:school2/providers/attendance.dart';
import '../providers/auth.dart';
import './item.dart';
import 'dart:math';

class FireBaseTryScreen extends StatefulWidget {
  @override
  _FireBaseTryScreenState createState() => _FireBaseTryScreenState();
}

class _FireBaseTryScreenState extends State<FireBaseTryScreen> {
  String classFirst;
  String classLast;
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
              // CollectionReference syllabus =
              //     FirebaseFirestore.instance.collection('syllabus');
              // QuerySnapshot response = await syllabus.get();
              // QueryDocumentSnapshot syl = response.docs[0];
              // Map<Duration, String> map = {};
              // List<Duration> liste = [];
              // syl["monday"].forEach((key, value) {
              //   // print(key);
              //   DateTime date = DateTime.now();
              //   map[value.toDate().difference(date)] = key;
              //   liste.add(value.toDate().difference(date));
              // });
              // liste.sort();

              // String classFirst = map[liste.first].split("-").first;
              // String classLast = map[liste.first].split("-").last;
              // print(classLast);
              // QuerySnapshot ref = await FirebaseFirestore.instance
              //     .collection("students")
              //     .where('classFirst', isEqualTo: classFirst)
              //     .where("classLast", isEqualTo: classLast)
              //     .get();

              // ref.docs.forEach((element) {
              //   print(element["parentNumber"]);
              // });
            },
          ),
          SizedBox(
            width: double.infinity,
            child: Container(),
          ),
          FutureBuilder(
            future: Provider.of<Attendance>(context).getAttendance(),
            builder: (context, attendance) {
              if (attendance.connectionState == ConnectionState.waiting)
                return Center(child: CircularProgressIndicator());
              final data = attendance.data;
              // print(data);

              return Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    // print(data);
                    return ListTile(
                      title: Text(data[index]["displayName"]),
                    );
                  },
                  itemCount: data.length,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
