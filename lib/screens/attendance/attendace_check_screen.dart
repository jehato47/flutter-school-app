import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:intl/intl.dart';
import 'package:school2/widgets/attendance/attendance_list.dart';
import '../../providers/attendance.dart';
import '../../providers/auth.dart';
import '../../widgets/attendance/empty_info.dart';

class AttendanceCheckScreen extends StatefulWidget {
  static const url = "/attendance";
  @override
  _AttendanceCheckScreenState createState() => _AttendanceCheckScreenState();
}

class _AttendanceCheckScreenState extends State<AttendanceCheckScreen> {
  // TODO : Bu sayfaya gelinen tarihte mevcut yoklama varsa onu koy
  DateTime cdate;
  String titleDate;
  dynamic info;
  String token;
  String currentClass = "";
  String currentTime;
  Map<String, dynamic> attendance;
  String date;

  // Başta herkes gelmeyen olarak işaretleniyor daha sonra listelere dağılıyor
  // Öğrenci numarasını diğer tüm listelerden çıkartıp istenen listeye koyar
  void changeValues(int number, Map ourattendance, List second) {
    ourattendance.forEach((key, value) {
      // key : gelenler, gelmeyenler ...
      // value : [168, 169, ...]
      // print(attendance);
      if (value.contains(number)) {
        value.removeWhere((element) => element == number);

        if (!second.contains(number)) second.add(number);
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
        title: Text(DateFormat('d MMMM').format(DateTime.now()).toString()),
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
    attendance["ders"] = info["ders"];
    attendance["date"] = date;
    attendance["derssaati"] = currentTime;
    attendance["sınıf"] = currentClass;

    await Provider.of<Attendance>(context).sendAttendance(attendance, token);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    token = Provider.of<Auth>(context).token;
    info = Provider.of<Auth>(context).userInform;

    var args =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;

    if (args != null) {
      // Eğer ders programından gelmişse bu koşul çalışıyor
      cdate = args["date"];
      currentClass = args["class"];
      currentTime = DateFormat("HH-mm").format(cdate).toString();
      date = DateFormat("y-MM-dd").format(args["date"]).toString();
    } else {
      date = DateFormat("y-MM-dd").format(DateTime.now()).toString();
      cdate = DateTime.now();
    }

    return FutureBuilder(
      future: Provider.of<Attendance>(context, listen: false)
          .getNearestAttendanceWithDetails(
              token, date, currentTime, currentClass),
      builder: (context, snapshot) {
        attendance =
            Provider.of<Attendance>(context, listen: false).oldAttendance;

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text("Yoklama al"),
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        currentClass = Provider.of<Attendance>(context).currentClass;
        currentTime = Provider.of<Attendance>(context).currentTime;
        cdate = Provider.of<Attendance>(context).date;
        if (cdate != null) titleDate = DateFormat("dd MMMM").format(cdate);
        String appBarTitle = currentClass == ""
            ? "Yoklama al"
            : "${currentClass.toUpperCase()} $titleDate $currentTime";

        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(appBarTitle),
            actions: [
              IconButton(
                icon: Icon(Icons.done),
                onPressed: sendAttendance,
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildElevatedButton(),
                currentClass == ""
                    ? Expanded(child: EmptyInfo())
                    : Expanded(child: AttendanceList(attendance, changeValues)),
              ],
            ),
          ),
        );
      },
    );
  }
}
