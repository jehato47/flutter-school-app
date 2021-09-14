import 'package:flutter/material.dart';
import '../../providers/attendance.dart';
import '../../screens/attendance/attendance_detail_screen.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:provider/provider.dart';

class AttendancePreviewScreen extends StatefulWidget {
  static const url = "/attendance-preview";

  @override
  _AttendancePreviewScreenState createState() =>
      _AttendancePreviewScreenState();
}

class _AttendancePreviewScreenState extends State<AttendancePreviewScreen> {
  late DateTime? startDate;
  late DateTime? endDate;
  List<dynamic> filteredDocs = [];
  List<String> classes = [];
  late String token;
  String currentClass = "11-c";

  showPickerModal(BuildContext context) async {
    final att = FirebaseFirestore.instance.collection('attendance');

    QuerySnapshot attendance = await att.get();
    classes = attendance.docs.map((e) => e.id).toList();
    Picker(
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
            filteredDocs = [];
            print(currentClass);
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
              icon: const Icon(Icons.place),
              onPressed: () async {
                await showPickerModal(context);
              }),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () async {
              // setState(() {
              //   currentClass = "11-d";
              // });

              await showModalBottomSheet(
                context: context,
                builder: (context) => SfDateRangePicker(
                  view: DateRangePickerView.month,
                  // controller: _controller,
                  monthViewSettings: DateRangePickerMonthViewSettings(),
                  selectionMode: DateRangePickerSelectionMode.range,
                  onSelectionChanged:
                      (DateRangePickerSelectionChangedArgs args) {
                    PickerDateRange k = args.value;
                    startDate = k.startDate;
                    endDate = k.endDate;
                  },
                ),
              );

              setState(() {});
            },
          ),
        ],
        centerTitle: true,
        title: Text("Yoklama listesi"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('attendance/$currentClass/pieces')
                    .where(
                      "date",
                      isGreaterThanOrEqualTo: startDate,
                      isLessThanOrEqualTo: endDate,
                    )
                    .orderBy("date", descending: true)
                    .snapshots(),
                builder: (context, attendance) {
                  if (!attendance.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  List<dynamic> data;
                  if (filteredDocs.length == 0) {
                    data = attendance.data.docs;
                  } else {
                    data = filteredDocs;
                  }
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
