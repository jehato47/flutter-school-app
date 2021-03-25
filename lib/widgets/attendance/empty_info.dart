import 'package:flutter/material.dart';
import '../../screens/timetable/teacher_timetable_screen.dart';

class EmptyInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Yakın zamanda dersiniz bulunmamaktadır yukarıdan" +
              " bugünkü diğer listeleri seçebilir",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushReplacementNamed(
              TeacherTimetableScreen.url,
            );
          },
          child: Text("veya programa gidebilirsiniz"),
        ),
      ],
    );
  }
}
