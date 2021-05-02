import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/attendance/empty_info.dart';
import '../../providers/attendance.dart';
import '../../widgets/attendance/student_check_item.dart';
import '../../providers/StudentCheckBox/student_checkbox.dart';

class AttendanceList extends StatelessWidget {
  // final students;
  final Map attendance;
  final Function changeValues;
  AttendanceList(this.attendance, this.changeValues);
  // TODO : Eğer öğrencilerden bazıları hiçbir listede yoksa gelmeyenlere ekle
  @override
  Widget build(BuildContext context) {
    dynamic students = Provider.of<Attendance>(context).students;

    return students.length == 0
        ? EmptyInfo()
        : ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) {
              if (!attendance
                  .toString()
                  .contains(students[index].reference.toString()))
                attendance["empty"].add(students[index].reference);
              return ChangeNotifierProvider.value(
                value: StudentCheckBox(),
                child: StudentCheckItem(
                  students[index],
                  attendance,
                  changeValues,
                ),
              );
            },
          );
  }
}
