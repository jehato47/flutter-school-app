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
