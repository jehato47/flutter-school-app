import 'package:flutter/material.dart';
import '../../screens/home_screen.dart';
import '../../screens/attendance/attendace_check_screen.dart';
import '../../screens/timetable/teacher_timetable_screen.dart';
import '../../screens/exam/add_exam_result_screen.dart';
import '../../screens/etude/give_etude_screen.dart';
import '../../screens/exam/students_exam_list.dart';

class BottomNavbar extends StatefulWidget {
  @override
  _BottomNavbarState createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  dynamic body = HomeScreen();
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        // showSelectedLabels: false,
        // showUnselectedLabels: false,
        currentIndex: index,
        type: BottomNavigationBarType.fixed,
        onTap: (value) {
          if (value == 0) {
            setState(() {
              index = value;
              body = HomeScreen();
            });
          } else if (value == 1) {
            setState(() {
              index = value;
              body = AttendanceCheckScreen();
            });
          } else if (value == 2) {
            setState(() {
              index = value;
              body = TeacherTimetableScreen();
            });
          } else if (value == 3) {
            setState(() {
              index = value;
              body = StudentsExamList();
            });
          } else if (value == 4) {
            setState(() {
              index = value;
              body = GiveEtudeScreen();
            });
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Ana Sayfa",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: "Yoklama",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: "Program",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timeline),
            label: "Sınavlar",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.class_),
            label: "Etüt",
          ),
        ],
      ),
    );
  }
}
