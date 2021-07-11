import 'package:flutter/material.dart';
import '../../widgets/exam/exams_list.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../../providers/auth.dart';

class ExamsListScreen extends StatefulWidget {
  static const url = "exam-list";

  @override
  _ExamsListScreenState createState() => _ExamsListScreenState();
}

class _ExamsListScreenState extends State<ExamsListScreen> {
  dynamic userInfo;
  List classes;
  bool isTeacher;
  String clss;

  Future<void> showPickerModal(BuildContext context) async {
    new Picker(
        adapter: PickerDataAdapter<String>(pickerdata: classes),
        changeToFirst: true,
        hideHeader: false,
        confirmText: "Seç",
        cancelText: "Iptal",
        diameterRatio: 1.5,
        magnification: 1.2,
        // title: Text(DateFormat('d MMMM').format(DateTime.now()).toString()),
        onConfirm: (Picker picker, List value) {
          setState(() {
            clss = picker.getSelectedValues().first;
            // currentClass = picker.getSelectedValues().first;
            // filteredDocs = [];
            // print(currentClass);
          });
          // print(picker.getSelectedValues().last);
        }).showModal(this.context);
  }

  Widget build(BuildContext context) {
    userInfo = Provider.of<Auth>(context, listen: false).userInfo;
    isTeacher = userInfo["role"] == "teacher";
    classes = userInfo["classes"];

    if (clss == null && classes.length != 0) clss = classes[0];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        actions: [
          if (isTeacher)
            IconButton(
              onPressed: () async {
                await showPickerModal(context);
              },
              icon: Icon(Icons.filter_list),
            ),
        ],
        title: Text("Sınav Sonucu ${clss.toUpperCase()}"),
      ),
      body: ExamsList(clss),
    );
  }
}
