import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:intl/intl.dart';
import 'package:school2/widgets/attendance/attendance_list.dart';
import '../../providers/attendance.dart';
import '../../providers/auth.dart';
import '../../widgets/attendance/empty_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceCheckScreen extends StatefulWidget {
  static const url = "/attendance";
  @override
  _AttendanceCheckScreenState createState() => _AttendanceCheckScreenState();
}

class _AttendanceCheckScreenState extends State<AttendanceCheckScreen> {
  DateTime cdate;
  String titleDate;
  dynamic info;
  String token;
  String currentClass = "";
  String currentTime;
  Map<String, dynamic> attendance = {
    "arrivals": [],
    "lates": [],
    "permitted": [],
    "notExists": [],
  };
  String date;

  // Başta herkes gelmeyen olarak işaretleniyor daha sonra listelere dağılıyor
  // Öğrenci numarasını diğer tüm listelerden çıkartıp istenen listeye koyar
  void changeValues(DocumentReference ref, Map ourattendance, List second) {
    ourattendance.forEach((key, value) {
      // key : gelenler, gelmeyenler ...
      // value : [168, 169, ...]
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
    FirebaseAuth auth = FirebaseAuth.instance;
    CollectionReference syllabus =
        FirebaseFirestore.instance.collection('attendance');
    // attendance["classFirst"] = "11";
    // attendance["classLast"] = "a";
    await syllabus.doc(auth.currentUser.uid).set({
      "info": attendance,
      "date": DateTime.now(),
      "classFirst": "11",
      "classLast": "a",
    });
  }

  @override
  Widget build(BuildContext context) {
    token = Provider.of<Auth>(context).token;
    info = Provider.of<Auth>(context).userInform;

    var args =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;

    return FutureBuilder(
        future: Provider.of<Attendance>(context).getAttendance(),
        builder: (context, snapshot) {
          String currentClass = Provider.of<Attendance>(context).currentClass;
          DateTime currentTime = Provider.of<Attendance>(context).currentTime;

          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                DateFormat("d MMMM EEEE H:m").format(currentTime) +
                    " " +
                    currentClass.toUpperCase(),
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.done),
                  onPressed: sendAttendance,
                )
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildElevatedButton(),
                  currentClass == ""
                      ? Expanded(child: EmptyInfo())
                      : Expanded(
                          child: AttendanceList(attendance, changeValues)),
                ],
              ),
            ),
          );
        });
  }
}
