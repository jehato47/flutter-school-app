import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/timetable.dart';
import '../../providers/auth.dart';
import '../../widgets/timetable/timetable_calendar.dart';

class StudentTimetableScreen extends StatelessWidget {
  static const url = "student-timetable";
  @override
  Widget build(BuildContext context) {
    final token = Provider.of<Auth>(context).token;
    final userInfo = Provider.of<Auth>(context).userInform;

    return Scaffold(
      appBar: AppBar(
        title: Text("Student Timetable"),
      ),
      body: FutureBuilder(
        future: Provider.of<Timetable>(context, listen: false)
            .setStudentTimetables(token, userInfo),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          return TimetableCalendar(isTeacher: false);
        },
      ),
    );
  }
}
