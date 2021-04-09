import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../../providers/timetable.dart';
import '../../widgets/timetable/timetable_calendar.dart';

class TeacherTimetableScreen extends StatelessWidget {
  static const url = "/teacher-timetable";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ders Programı"),
      ),
      body: FutureBuilder(
        future: Provider.of<Timetable>(context).setTeacherTimetables(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(),
            );

          return TimetableCalendar(isTeacher: true);
        },
      ),
    );
  }
}
