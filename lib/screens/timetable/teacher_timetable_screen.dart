import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../../providers/timetable.dart';
import '../../widgets/timetable/timetable_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TeacherTimetableScreen extends StatelessWidget {
  static const url = "/teacher-timetable";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ders Programı"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("syllabus")
            // TODO : Production
            // .where("id", isEqualTo: "6mA6Bw7DIXrPwIaqGBS3")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(),
            );
          Provider.of<Timetable>(context).teacherData =
              snapshot.data.docs[0].data();

          return TimetableCalendar(isTeacher: true);
        },
      ),
    );
  }
}
