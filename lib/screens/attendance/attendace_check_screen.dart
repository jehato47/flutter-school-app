import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:intl/intl.dart';
import 'package:school2/screens/timetable/teacher_timetable_screen.dart';
import 'package:school2/widgets/attendance/attendance_list.dart';
import '../../providers/attendance.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceCheckScreen extends StatefulWidget {
  static const url = "/attendance";
  @override
  _AttendanceCheckScreenState createState() => _AttendanceCheckScreenState();
}

class _AttendanceCheckScreenState extends State<AttendanceCheckScreen> {
  String currentClass = "";
  DateTime currentTime;
  Map<String, dynamic> attendance;

  // Başta herkes gelmeyen olarak işaretleniyor daha sonra listelere dağılıyor
  // Öğrenci numarasını diğer tüm listelerden çıkartıp istenen listeye koyar
  void changeValues(DocumentReference ref, Map ourattendance, List second) {
    ourattendance.forEach((key, value) {
      // key : arrivals, notExists ...
      // value : [docRef, docRef, ...]
      // print(attendance);
      if (value.contains(ref)) {
        value.removeWhere((element) => element == ref);

        if (!second.contains(ref)) second.add(ref);
      }
    });
    print(ourattendance);
  }

  showPickerModal(BuildContext context) async {
    Map<String, dynamic> classes =
        await Provider.of<Attendance>(context).classes;

    new Picker(
        adapter: PickerDataAdapter<String>(pickerdata: [classes]),
        changeToFirst: true,
        hideHeader: false,
        confirmText: "Seç",
        cancelText: "Iptal",
        title: Text(
          DateFormat('d MMMM EEEE').format(DateTime.now()).toString(),
        ),
        magnification: 1.2,
        onConfirm: (Picker picker, List value) {
          setState(() {
            currentClass = picker.getSelectedValues().first;
            currentTime = picker.getSelectedValues().last;
          });
        }).showModal(this.context);
  }

  Widget buildElevatedButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        child: Text("Sınıf seç"),
        onPressed: () {
          showPickerModal(context);
        },
      ),
    );
  }

  Future<void> sendAttendance() async {
    await FirebaseFirestore.instance
        .collection('attendance')
        .doc(currentClass)
        .set({});
    // CollectionReference att = FirebaseFirestore.instance
    //     .collection('attendance/classes/$currentClass');
    CollectionReference att = FirebaseFirestore.instance
        .collection('attendance/$currentClass/pieces');

    // Todo : Kurumlara göre ayırdığın zaman bunları düzlenle
    // Todo : referans beskalem/attendance/currentClass olsun

    await att.doc(currentTime.toString()).set({
      "info": attendance,
      "date": currentTime,
      "classFirst": currentClass.split("-").first,
      "classLast": currentClass.split("-").last,
      "lecture": "matematik",
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    var args =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    if (args != null) {
      currentTime = args["date"];
      currentClass = args["class"];
    }
    return FutureBuilder(
        future: Provider.of<Attendance>(context).getAttendance(
          currentClass,
          currentTime,
        ),
        builder: (context, snapshot) {
          try {
            attendance = Provider.of<Attendance>(context).attendance;
            if (attendance == null) throw Error();
          } catch (err) {
            attendance = {
              "arrivals": [],
              "lates": [],
              "permitted": [],
              "notExists": [],
            };
          }

          if (snapshot.connectionState == ConnectionState.waiting)
            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text("Alınıyor"),
              ),
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          currentClass = Provider.of<Attendance>(context).currentClass;
          currentTime = Provider.of<Attendance>(context).currentTime;

          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                "${DateFormat("E HH:mm").format(currentTime)}" +
                    " ${currentClass.toUpperCase()}",
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.calendar_today_outlined),
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacementNamed(TeacherTimetableScreen.url);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.done),
                  onPressed: sendAttendance,
                )
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(10),
              child: AttendanceList(attendance, changeValues),
            ),
          );
        });
  }
}
