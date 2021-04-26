import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/StudentCheckBox/student_checkbox.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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
    if (attendance["arrivals"].contains(student.reference)) {
      checkbox.setIsChecked(true);
      color = Colors.green;
    }
    if (attendance["notExists"].contains(student.reference)) {
      color = Colors.green;
    }
    if (attendance["permitted"].contains(student.reference)) {
      checkbox.setIsChecked(true);
      color = Colors.blue;
    }
    if (attendance["lates"].contains(student.reference)) {
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

  Future<Widget> showStudentDetailDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("ok"))
        ],
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image(
              height: 200,
              fit: BoxFit.cover,
              image: NetworkImage(
                "https://firebasestorage.googleapis.com/v0/b/school-f162e.appspot.com/o/default.jpg?alt=media&token=98ab15cf-2ea9-43db-a725-970650e5df5f",
              ),
            ),
            SizedBox(height: 10),
            Text("Ad Soyad : ${student["name"]} ${student["surname"]}"),
            Text("Sınıf : ${student["classFirst"]} ${student["classLast"]}"),
            Text("number : ${student["number"]}"),
            Text("Ad Soyad : Jehat Armanç Deniz"),
            Text("Ad Soyad : Jehat Armanç Deniz"),
          ],
        ),
      ),
    );
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
        elevation: 2,
        child: InkWell(
          onLongPress: () {
            showStudentDetailDialog(context);
          },
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
                    student.reference,
                    attendance,
                    attendance["permitted"],
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
                    student.reference,
                    attendance,
                    attendance["lates"],
                  );

                  if (!checkbox.isChecked) checkbox.change();
                },
              ),
            ],
            child: CheckboxListTile(
              activeColor: color,
              title: Text(student["name"] + " " + student["surname"]),
              subtitle: Text(student["number"].toString()),
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
                    student.reference,
                    attendance,
                    attendance["arrivals"],
                  );
                else {
                  changeValues(
                    student.reference,
                    attendance,
                    attendance["notExists"],
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
