import 'package:flutter/material.dart';
import '../../screens/timetable/teacher_timetable_screen.dart';

class NoLectureInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Bugün dersiniz bulunmamaktadır",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed(
                    TeacherTimetableScreen.url,
                  );
                },
                child: Text("isterseniz programa gidebilirsiniz"),
              ),
            ],
          ),
        ));
  }
}
