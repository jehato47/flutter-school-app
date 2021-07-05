import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:school2/screens/exam/exams_list_screen.dart';
import 'package:school2/widgets/home/side_drawer.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/attendance/attendace_check_screen.dart';
import '../../screens/timetable/teacher_timetable_screen.dart';
import '../../screens/etude/etude_requests_screen.dart';
import '../../widgets/home/ring_bell.dart';
import '../../widgets/home/homework_button.dart';

class TeacherHomeScreen extends StatefulWidget {
  @override
  _TeacherHomeScreenState createState() => _TeacherHomeScreenState();
}

class _TeacherHomeScreenState extends State<TeacherHomeScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  int index = 0;
  dynamic body;

  @override
  void initState() {
    body = HomeScreen(setIndex);

    super.initState();
  }

  void setIndex(value) {
    if (index == value) return;

    if (value == 0) {
      setState(() {
        index = value;
        body = HomeScreen(setIndex);
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
        body = ExamsListScreen();
      });
    } else if (value == 4) {
      setState(() {
        index = value;
        body = EtudeRequestsScreen();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => Scaffold(
        appBar: index != 0
            ? null
            : AppBar(
                actions: [
                  RingBell(),
                  HomeworkButton(),
                ],
                title: Text(auth.currentUser.displayName),
              ),
        drawer: index == 0 ? SideDrawer() : null,
        body: body,
        bottomNavigationBar: BottomNavigationBar(
          // showSelectedLabels: false,
          // showUnselectedLabels: false,

          currentIndex: index,
          type: BottomNavigationBarType.fixed,
          onTap: setIndex,
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
      ),
    );
  }
}
