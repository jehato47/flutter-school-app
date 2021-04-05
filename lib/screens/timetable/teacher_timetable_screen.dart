import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../../providers/auth.dart';
import '../../providers/timetable.dart';
import '../../widgets/timetable/timetable_calendar.dart';

class TeacherTimetableScreen extends StatelessWidget {
  static const url = "/teacher-timetable";

  @override
  Widget build(BuildContext context) {
    final token = Provider.of<Auth>(context).token;
    final info = Provider.of<Auth>(context).userInform;
    return Scaffold(
      appBar: AppBar(title: Text("Ders Programı"),),
      body: info["ders"] == null
          ? Center(child: Text("Öğretmen olarak giriş yapın"))
          : FutureBuilder(
              future: Provider.of<Timetable>(context)
                  .setTeacherTimetables(token, info),
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
