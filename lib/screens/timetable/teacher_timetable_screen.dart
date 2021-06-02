import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../../providers/timetable.dart';
import '../../widgets/timetable/timetable_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TeacherTimetableScreen extends StatelessWidget {
  static const url = "/teacher-timetable";

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;

    return Scaffold(
      appBar: AppBar(
        title: Text("Ders Programı"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("syllabus")
            // TODO : Production
            .doc("mF1uyNyCqLaXDf88zB47ZZqSuWh2")
            // .doc(auth.currentUser.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(),
            );
          Provider.of<Timetable>(context, listen: false).teacherData =
              snapshot.data.docs[0].data();

          Provider.of<Timetable>(context).teacherData = snapshot.data.data();
          return TimetableCalendar(isTeacher: true);
        },
      ),
    );
  }
}
