import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_picker/Picker.dart';
import 'package:intl/intl.dart';
import '../../screens/timetable/teacher_timetable_screen.dart';
import '../../widgets/attendance/attendance_list.dart';
import '../../widgets/attendance/empty_info.dart';
import '../../providers/attendance.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/attendance/no_lecture_info.dart';

class AttendanceCheckScreen extends StatefulWidget {
  static const url = "/attendance";
  @override
  _AttendanceCheckScreenState createState() => _AttendanceCheckScreenState();
}

class _AttendanceCheckScreenState extends State<AttendanceCheckScreen> {
  dynamic args;
  bool isSent = false;
  String currentClass = "";
  DateTime currentTime;
  dynamic attendance;
  bool showCalendarButton = true;

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
  }

  // showPickerModal(BuildContext context) async {
  //   Map<String, dynamic> classes =
  //       await Provider.of<Attendance>(context).classes;

  //   Picker(
  //       adapter: PickerDataAdapter<String>(pickerdata: [classes]),
  //       changeToFirst: true,
  //       hideHeader: false,
  //       confirmText: "Seç",
  //       cancelText: "Iptal",
  //       title: Text(
  //         DateFormat('d MMMM EEEE').format(DateTime.now()).toString(),
  //       ),
  //       magnification: 1.2,
  //       onConfirm: (Picker picker, List value) {
  //         setState(() {
  //           currentClass = picker.getSelectedValues().first;
  //           currentTime = picker.getSelectedValues().last;
  //         });
  //       }).showModal(this.context);
  // }

  // Widget buildElevatedButton() {
  //   return SizedBox(
  //     width: double.infinity,
  //     child: ElevatedButton(
  //       child: Text("Sınıf seç"),
  //       onPressed: () {
  //         showPickerModal(context);
  //       },
  //     ),
  //   );
  // }

  Future<void> sendAttendance() async {
    if (true) {
      isSent = true;

      await FirebaseFirestore.instance
          .collection('attendance')
          .doc(currentClass)
          .set({});

      CollectionReference att = FirebaseFirestore.instance
          .collection('attendance/$currentClass/pieces');

      // ? TODO : Kurumlara göre ayırdığın zaman bunları düzlenle
      // ? TODO : referans beskalem/attendance/currentClass olsun

      await att.doc(currentTime.toString()).set({
        "info": attendance,
        "date": currentTime,
        "classFirst": currentClass.split("-").first,
        "classLast": currentClass.split("-").last,
        // TODO : production
        "lecture": "matematik",
      });
      // Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          // margin: args != null
          //     ? null
          //     : EdgeInsets.only(bottom: 70, left: 10, right: 10),
          behavior: SnackBarBehavior.floating,
          content: Text("Yoklama alındı"),
          backgroundColor: Colors.green,
          duration: Duration(milliseconds: 500),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    // ! TODO : Tehlike
    args = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    if (args != null) {
      // Program - Yoklama - Program döngüsüne girmemesi için
      // sadece yoklama sayfasında buton gözükecek
      showCalendarButton = false;
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
            // Eğer seçilen günde hiç ders yoksa
            if (attendance.length == 0)
              return NoLectureInfo();
            else if (attendance == null) throw Error();
          } catch (err) {
            attendance = {
              "arrivals": [],
              "lates": [],
              "permitted": [],
              "notExists": [],
              "empty": [],
            };
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text("Alınıyor"),
              ),
              body: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          currentClass = Provider.of<Attendance>(context).currentClass;
          currentTime = Provider.of<Attendance>(context).currentTime;

          return Scaffold(
            // floatingActionButtonLocation:
            //     FloatingActionButtonLocation.miniEndFloat,
            // floatingActionButton: !showCalendarButton
            //     ? null
            //     : FloatingActionButton(
            //         child: IconButton(
            //           icon: const Icon(Icons.calendar_today_outlined),
            //           onPressed: () {
            //             Navigator.of(context)
            //                 .pushNamed(TeacherTimetableScreen.url);
            //           },
            //         ),
            //         onPressed: () {},
            //       ),
            appBar: AppBar(
              // centerTitle: true,
              title: Text(
                DateFormat("E HH:mm").format(currentTime) +
                    " ${currentClass.toUpperCase()}",
              ),
              actions: [
                !showCalendarButton
                    ? Container()
                    : IconButton(
                        icon: const Icon(Icons.calendar_today_outlined),
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(TeacherTimetableScreen.url);
                        },
                      ),

                // if (showCalendarButton)
                //   IconButton(
                //     icon: Icon(Icons.calendar_today_outlined),
                //     onPressed: () {
                //       Navigator.of(context)
                //           .pushNamed(TeacherTimetableScreen.url);
                //     },
                //   ),
                IconButton(
                  icon: const Icon(Icons.done),
                  onPressed: sendAttendance,
                )
              ],
            ),
            body: Padding(
              padding: EdgeInsets.all(size.width / 40),
              child: AttendanceList(attendance, changeValues),
            ),
          );
        });
  }
}
