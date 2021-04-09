import 'package:flutter/material.dart';
import '../../providers/attendance.dart';
import '../../screens/attendance/attendance_detail_screen.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AttendancePreviewScreen extends StatefulWidget {
  static const url = "/attendance-preview";

  @override
  _AttendancePreviewScreenState createState() =>
      _AttendancePreviewScreenState();
}

class _AttendancePreviewScreenState extends State<AttendancePreviewScreen> {
  List<String> classes = [];
  String token;
  String currentClass = "11-c";

  showPickerModal(BuildContext context) async {
    new Picker(
        adapter: PickerDataAdapter<String>(pickerdata: classes),
        changeToFirst: true,
        hideHeader: false,
        confirmText: "Seç",
        cancelText: "Iptal",
        diameterRatio: 1.5,
        magnification: 1.2,
        title: Text(DateFormat('d MMMM').format(DateTime.now()).toString()),
        onConfirm: (Picker picker, List value) {
          setState(() {
            currentClass = picker.getSelectedValues().first;
          });
          // print(picker.getSelectedValues().last);
        }).showModal(this.context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {},
          )
        ],
        centerTitle: true,
        title: Text("Yoklama listesi"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('attendance/classes/11-c')
                    .orderBy("date", descending: true)
                    .get(),
                builder: (context, attendance) {
                  if (attendance.connectionState == ConnectionState.waiting)
                    return Center(child: CircularProgressIndicator());
                  final data = attendance.data.docs;
                  // print(data);
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      // print(data);
                      final attendance = data[index];
                      return ListTile(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            AttendanceDetailScreen.url,
                            arguments: attendance,
                          );
                        },
                        title: Text(
                          attendance["lecture"] +
                              " " +
                              attendance["classFirst"] +
                              "-" +
                              attendance["classLast"].toUpperCase(),
                        ),
                        subtitle: Text(
                          DateFormat("y-MM-dd : HH:mm").format(
                            attendance["date"].toDate(),
                          ),
                        ),
                        trailing: Text(
                          "V-"
                          "${attendance["info"]["arrivals"].length} /"
                          "Y-"
                          "${attendance["info"]["notExists"].length} /"
                          "I-"
                          "${attendance["info"]["permitted"].length} /"
                          "G-"
                          "${attendance["info"]["lates"].length}",
                        ),
                      );
                    },
                    itemCount: data.length,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
