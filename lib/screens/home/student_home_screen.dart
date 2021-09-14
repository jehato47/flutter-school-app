import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../screens/etude/my_etudes_screen.dart';
import '../../screens/homework/homework_preview_screen.dart';
import '../../screens/timetable/student_timetable_screen.dart';
import '../../widgets/home/side_drawer.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/timetable/teacher_timetable_screen.dart';
import '../../screens/exam/student_exam_screen.dart';
import '../../widgets/home/ring_bell.dart';
import '../../widgets/home/archive_button.dart';

class StudentHomeScreen extends StatefulWidget {
  @override
  _StudentHomeScreenState createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  // dynamic body = HomeScreen();
  dynamic body;

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
        body = HomeworkPreviewScreen();
      });
    } else if (value == 2) {
      setState(() {
        index = value;
        body = StudentTimetableScreen();
      });
    } else if (value == 3) {
      setState(() {
        index = value;
        body = StudentExamScreen();
      });
    } else if (value == 4) {
      setState(() {
        index = value;
        body = MyEtudesScreen();
      });
    }
  }

  @override
  void initState() {
    body = HomeScreen(setIndex);

    super.initState();
  }

  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: index != 0
          ? null
          : AppBar(
              actions: [
                ArchiveButton(),
                RingBell(),
              ],
              title: Text(auth.currentUser!.displayName as String),
            ),
      drawer: index == 0 ? SideDrawer() : null,
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        // showSelectedLabels: false,
        // showUnselectedLabels: false,

        currentIndex: index,
        type: BottomNavigationBarType.fixed,
        onTap: setIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Ana Sayfa",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: "Ödevler",
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
