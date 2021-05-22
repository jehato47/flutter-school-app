import 'package:flutter/material.dart';
import '../../screens/exam/student_exam_screen.dart';
import '../../screens/attendance/attendace_check_screen.dart';
import '../../screens/attendance/attendance_preview_screen.dart';
import '../../screens/homework/give_homework_screen.dart';
import '../../screens/homework/homework_preview_screen.dart';
import '../../screens/timetable/teacher_timetable_screen.dart';
import '../../screens/timetable/student_timetable_screen.dart';
import '../../screens/exam/students_exam_list.dart';
import '../../screens/etude/give_etude_screen.dart';
import '../../screens/etude/etude_chat_screen.dart';
import '../../screens/etude/my_etudes_screen.dart';
import 'page_grid_item.dart';

class PagesGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // print(size.width);
    double width = size.width;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: GridView(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 1,
          crossAxisCount: width >= 700 ? 4 : 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        children: [
          PageGridItem(
            AttendanceCheckScreen.url,
            "Yoklama",
            "subtitle",
          ),
          PageGridItem(
            AttendancePreviewScreen.url,
            "Yoklamalar",
            "subtitle",
          ),
          PageGridItem(
            GiveHomeworkScreen.url,
            "Ödev Ver",
            "subtitle",
          ),
          PageGridItem(
            HomeworkPreviewScreen.url,
            "Ödevler",
            "subtitle",
          ),
          PageGridItem(
            TeacherTimetableScreen.url,
            "T Ders P.",
            "subtitle",
          ),
          PageGridItem(
            StudentTimetableScreen.url,
            "S. Ders P.",
            "subtitle",
          ),
          PageGridItem(
            StudentsExamList.url,
            "Sınav S.",
            "subtitle",
          ),
          PageGridItem(
            StudentExamScreen.url,
            "Öğrenci S.",
            "subtitle",
          ),
          PageGridItem(
            GiveEtudeScreen.url,
            "Etüt Ver",
            "subtitle",
          ),
          // PageGridItem(
          //   StudentEtudeScreen.url,
          //   "Etüt Al",
          //   "subtitle",
          // ),
          PageGridItem(
            MyEtudesScreen.url,
            "Etütlerim",
            "subtitle",
          ),
        ],
      ),
    );
  }
}
