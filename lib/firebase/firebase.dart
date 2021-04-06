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
              attendance = FirebaseFirestore.instance.collection('attendance');
              QuerySnapshot response = await attendance.get();
              print(response.docs[0]);
            },
          ),
          SizedBox(
            width: double.infinity,
            child: Container(),
          ),
          FutureBuilder(
            future: FirebaseFirestore.instance.collection('attendance').get(),
            builder: (context, attendance) {
              if (attendance.connectionState == ConnectionState.waiting)
                return Center(child: CircularProgressIndicator());
              final data = attendance.data.docs;
              // print(data);

              return Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    // print(data);
                    final attendance = data[index];
                    return ListTile(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          AttendanceDetailScreen.url,
                          arguments: attendance,
                        );
                      },
                      title: Text(
                        attendance["lecture"] +
                            " " +
                            attendance["classFirst"] +
                            "-" +
                            attendance["classLast"].toUpperCase(),
                      ),
                      subtitle: Text(
                        DateFormat("y-MM-dd : HH:mm").format(
                          attendance["date"].toDate(),
                        ),
                      ),
                      trailing: Text(
                        "V-"
                        "${attendance["info"]["arrivals"].length} /"
                        "Y-"
                        "${attendance["info"]["notExists"].length} /"
                        "I-"
                        "${attendance["info"]["permitted"].length} /"
                        "G-"
                        "${attendance["info"]["lates"].length}",
                      ),
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
