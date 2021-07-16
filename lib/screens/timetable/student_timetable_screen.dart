import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/timetable.dart';
import '../../widgets/timetable/timetable_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../providers/auth.dart';
//import 'package:provider/provider.dart';

class StudentTimetableScreen extends StatelessWidget {
  static const url = "student-timetable";
  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<Auth>(context).userInfo;
    String studentClass = userInfo["classFirst"] + "-" + userInfo["classLast"];

    return Scaffold(
      appBar: AppBar(
        title: Text("Ders Programı"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("timetable")
            .where("uids", arrayContainsAny: [
          "jlc9EUKfpmcTXKFopVfbc1B0edD2",
          "11-a",
        ])

            // TODO : Production
            // .where("id", isEqualTo: "6mA6Bw7DIXrPwIaqGBS3")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());

          Provider.of<Timetable>(context).studentData = snapshot.data.docs;
          return TimetableCalendar(isTeacher: false);
        },
      ),
    );
  }
}
