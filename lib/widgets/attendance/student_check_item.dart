import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/StudentCheckBox/student_checkbox.dart';
import '../../helpers/envs.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../providers/attendance.dart';

class StudentCheckItem extends StatefulWidget {
  final dynamic student;
  final Map attendance;
  final Function changeValues;
  StudentCheckItem(this.student, this.attendance, this.changeValues);

  @override
  _StudentCheckItemState createState() => _StudentCheckItemState();
}

class _StudentCheckItemState extends State<StudentCheckItem> {
  void setItem() {
    if (attendance["gelenler"].contains(student["no"])) {
      checkbox.setIsChecked(true);
      color = Colors.green;
    }
    if (attendance["gelmeyenler"].contains(student["no"])) {
      color = Colors.green;
    }
    if (attendance["izinliler"].contains(student["no"])) {
      checkbox.setIsChecked(true);
      color = Colors.blue;
    }
    if (attendance["geç_gelenler"].contains(student["no"])) {
      checkbox.setIsChecked(true);
      color = Colors.red;
    }
  }

  @override
  void didChangeDependencies() {
    if (isInit) {
      attendance = widget.attendance as Map<String, dynamic>;
      student = widget.student;
      changeValues = widget.changeValues;
      checkbox = Provider.of<StudentCheckBox>(context);

      setItem();
    }
    isInit = false;
    super.didChangeDependencies();
  }

  // TODO : Öğrenciye uzun basıldığında bazı detayları göstermeye bak
  Map<String, dynamic> attendance;
  dynamic student;
  Function changeValues;
  Color color = Colors.green;
  StudentCheckBox checkbox;
  bool isInit = true;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: StudentCheckBox(),
      child: Card(
        elevation: 4,
        child: Slidable(
          // actionExtentRatio: 0.75 / 2,

          actionPane: SlidableDrawerActionPane(),
          secondaryActions: [
            IconSlideAction(
              caption: "İzinli",
              icon: Icons.how_to_reg,
              color: Colors.blue,
              onTap: () {
                setState(() {
                  color = Colors.blue;
                });
                changeValues(
                  student["no"],
                  attendance,
                  attendance["izinliler"],
                );

                if (!checkbox.isChecked) {
                  checkbox.change();
                }
              },
            ),
            IconSlideAction(
              caption: "Geç geldi",
              icon: Icons.alarm,
              color: Colors.red,
              onTap: () {
                setState(() {
                  color = Colors.red;
                });
                changeValues(
                  student["no"],
                  attendance,
                  attendance["geç_gelenler"],
                );

                if (!checkbox.isChecked) checkbox.change();
              },
            ),
          ],
          child: CheckboxListTile(
            activeColor: color,
            title: Text(student["isim"] + " " + student["soyisim"]),
            subtitle: Text(student["no"].toString()),
            value: checkbox.isChecked,
            onChanged: (v) {
              if (checkbox.isChecked == false) {
                print(12);
                setState(() {
                  color = Colors.green;
                });
              }
              checkbox.change();
              if (checkbox.isChecked)
                changeValues(
                  student["no"],
                  attendance,
                  attendance["gelenler"],
                );
              else {
                changeValues(
                  student["no"],
                  attendance,
                  attendance["gelmeyenler"],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
