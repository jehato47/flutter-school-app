import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/timetable.dart';
import '../../widgets/timetable/timetable_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentTimetableScreen extends StatelessWidget {
  static const url = "student-timetable";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ders Programı"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("studentsyllabus")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());

          Provider.of<Timetable>(context).studentData =
              snapshot.data.docs[0].data();
          return TimetableCalendar(isTeacher: false);
        },
      ),
    );
  }
}
