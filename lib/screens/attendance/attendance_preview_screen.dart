import 'package:flutter/material.dart';
import '../../providers/attendance.dart';
import 'package:provider/provider.dart';
import '../../providers/auth.dart';
import '../../screens/attendance/attendance_detail_screen.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:intl/intl.dart';

class AttendancePreviewScreen extends StatefulWidget {
  static const url = "/attendance-preview";

  @override
  _AttendancePreviewScreenState createState() =>
      _AttendancePreviewScreenState();
}

class _AttendancePreviewScreenState extends State<AttendancePreviewScreen> {
  String token;
  String currentClass = "11-a";

  showPickerModal(BuildContext context) async {
    List classes = await Provider.of<Attendance>(context).allClasses;

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
    token = Provider.of<Auth>(context).token;
    return Scaffold(
      appBar: AppBar(
        title: Text("Yoklama listesi"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                child: Text("sınıfı seç"),
                // style: ButtonStyle(
                //   backgroundColor: MaterialStateProperty.all<Color>(
                //     Colors.pink,
                //   ),
                // ),
                onPressed: () {
                  showPickerModal(context);
                },
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: Provider.of<Attendance>(context)
                    .getAttendanceByClass(token, currentClass),
                builder: (context, snapshot) {
                  Provider.of<Attendance>(context)
                      .getAllClassNamesForAttendancePreview(token);

                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(child: CircularProgressIndicator());
                  // if (snapshot.data == null) return Container();
                  List liste = snapshot.data;
                  liste = liste.reversed.toList();

                  return ListView.builder(
                    itemCount: liste.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          InkWell(
                            onTap: () async {
                              Navigator.of(context).pushNamed(
                                AttendanceDetailScreen.url,
                                arguments: liste[index],
                              );
                            },
                            child: ListTile(
                              title: Text(
                                "${liste[index]["ders"]} ${liste[index]["sınıf"].toUpperCase()}",
                              ),
                              subtitle: Text(
                                  "${liste[index]["date"]} : ${liste[index]["derssaati"]}"),
                              trailing: Text(
                                "V-"
                                "${liste[index]["gelenler"].length} /"
                                "Y-"
                                "${liste[index]["gelmeyenler"].length} /"
                                "I-"
                                "${liste[index]["izinliler"].length} /"
                                "G-"
                                "${liste[index]["geç_gelenler"].length}",
                              ),
                            ),
                          ),
                          Divider(thickness: 1),
                        ],
                      );
                    },
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
