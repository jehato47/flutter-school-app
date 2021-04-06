import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/attendance.dart';
import '../widgets/attendance/student_check_item.dart';
import '../providers/StudentCheckBox/student_checkbox.dart';

class AttendanceScreen extends StatefulWidget {
  static const url = "attendance-try";
  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: Provider.of<Attendance>(context).getAttendance(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          final students = snapshot.data;
          print(students);
          return ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) => ChangeNotifierProvider.value(
              value: StudentCheckBox(),
              child: StudentCheckItem(
                students[index],
                {},
                () {},
              ),
            ),
          );
        },
      ),
    );
  }
}
