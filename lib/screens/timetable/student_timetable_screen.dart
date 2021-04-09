import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/timetable.dart';
import '../../widgets/timetable/timetable_calendar.dart';

class StudentTimetableScreen extends StatelessWidget {
  static const url = "student-timetable";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ders Programı"),
      ),
      body: FutureBuilder(
        future: Provider.of<Timetable>(context, listen: false)
            .setStudentTimetables(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          return TimetableCalendar(isTeacher: false);
        },
      ),
    );
  }
}
