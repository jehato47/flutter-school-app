import 'package:flutter/material.dart';
import '../../screens/timetable/teacher_timetable_screen.dart';

class EmptyInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Bu sınıfa henüz öğrenci kayıt edilmemiş olabilir",
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
    );
  }
}
