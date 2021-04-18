import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:school2/providers/attendance.dart';
import '../providers/auth.dart';
import './item.dart';
import 'dart:math';
import '../screens/attendance/attendance_detail_screen.dart';
import 'package:intl/intl.dart';

class FireBaseTryScreen extends StatefulWidget {
  @override
  _FireBaseTryScreenState createState() => _FireBaseTryScreenState();
}

class _FireBaseTryScreenState extends State<FireBaseTryScreen> {
  String classFirst;
  String classLast;
  CollectionReference attendance;
  List<String> days = [
    "monday",
    "tuesday",
    "wednesday",
    "thursday",
    "friday",
    "saturday",
    "sunday"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            child: Text("send"),
            onPressed: () async {
              FirebaseAuth auth = FirebaseAuth.instance;
              // await Provider.of<Auth>(context).signStudentUp(
              //   "akcagrkcagc@hotmail.com",
              //   "123465789",
              //   "jehato231",
              //   "Emine Münevver",
              //   "Akcaağırkocaağaç",
              //   2023,
              //   "11",
              //   "c",
              //   "05366639292",
              //   "https://firebasestorage.googleapis.com/v0/b/school-f162e.appspot.com/o/default.jpg?alt=media&token=98ab15cf-2ea9-43db-a725-970650e5df5f",
              // );
              CollectionReference ref =
                  FirebaseFirestore.instance.collection("students");

              final docs = await ref.get();
              print(docs.docs[0].id);

              CollectionReference ref2 =
                  FirebaseFirestore.instance.collection("exam");
              docs.docs.forEach((element) {
                ref2.doc(element.id).set({
                  "number": element["number"],
                  "displayName": element["displayName"],
                  "classFirst": element["classFirst"],
                  "classLast": element["classLast"],
                  "matematik": {
                    "1": null,
                    "2": null,
                    "3": null,
                  },
                  "fizik": {
                    "1": null,
                    "2": null,
                  },
                  "biyoloji": {
                    "1": null,
                    "2": null,
                  },
                  "kimya": {
                    "1": null,
                    "2": null,
                  },
                  "türkçe": {
                    "1": null,
                    "2": null,
                    "3": null,
                  }
                });
              });
            },
          ),
          SizedBox(
            width: double.infinity,
            child: Container(),
          ),
        ],
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:provider/provider.dart';
// import 'package:school2/providers/attendance.dart';
// import '../providers/auth.dart';
// import './item.dart';
// import 'dart:math';
// import '../screens/attendance/attendance_detail_screen.dart';
// import 'package:intl/intl.dart';

// // import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_datepicker/datepicker.dart';

// class FireBaseTryScreen extends StatefulWidget {
//   @override
//   _FireBaseTryScreenState createState() => _FireBaseTryScreenState();
// }

// class _FireBaseTryScreenState extends State<FireBaseTryScreen> {
//   final DateRangePickerController _controller = DateRangePickerController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: <Widget>[
//           Card(
//             margin: const EdgeInsets.fromLTRB(50, 150, 50, 100),
//             child: SfDateRangePicker(
//               view: DateRangePickerView.month,
//               controller: _controller,
//               monthViewSettings: DateRangePickerMonthViewSettings(),
//               selectionMode: DateRangePickerSelectionMode.multiRange,
//               onSelectionChanged: selectionChanged,
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   void selectionChanged(DateRangePickerSelectionChangedArgs args) {
//     // final List<PickerDateRange> dateRanges =
//     //     (args.value as List<PickerDateRange>);
//     // final DateTime date = dateRanges.isNotEmpty
//     //     ? dateRanges[dateRanges.length - 1].startDate
//     //     : null;

//     print(args.value);
//     // if (date != null &&
//     //     _controller.selectedRanges != null &&
//     //     dateRanges[dateRanges.length - 1].endDate == null) {
//     // _controller.selectedRanges = <PickerDateRange>[
//     //   PickerDateRange(
//     //       date.add(Duration(days: -3)), date.add(Duration(days: -1))),
//     //   PickerDateRange(
//     //       date.add(Duration(days: 1)), date.add(Duration(days: 3)))
//     // ];
//     // }
//   }
// }
