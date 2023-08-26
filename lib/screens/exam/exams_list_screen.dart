import 'package:flutter/material.dart';
import '../../widgets/exam/exams_list.dart';
// import 'package:flutter_picker/Picker.dart';
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
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SizedBox(
          width: 50,
          child: ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index) => ListTile(
              onTap: () {
                setState(() {
                  clss = classes[index];
                });
                Navigator.of(context).pop();
              },
              title: Text(classes[index]),
            ),
            itemCount: classes.length,
          ),
        ),
      ),
    );
    return;
    // new Picker(
    //     adapter: PickerDataAdapter<String>(pickerdata: classes),
    //     changeToFirst: true,
    //     hideHeader: false,
    //     confirmText: "Seç",
    //     cancelText: "Iptal",
    //     diameterRatio: 1.5,
    //     magnification: 1.2,
    //     // title: Text(DateFormat('d MMMM').format(DateTime.now()).toString()),
    //     onConfirm: (Picker picker, List value) {
    //       setState(() {
    //         clss = picker.getSelectedValues().first;
    //         // currentClass = picker.getSelectedValues().first;
    //         // filteredDocs = [];
    //         // print(currentClass);
    //       });
    //       // print(picker.getSelectedValues().last);
    //     }).showModal(this.context);
  }

  Widget build(BuildContext context) {
    userInfo = Provider.of<Auth>(context, listen: false).userInfo;
    isTeacher = userInfo["role"] == "teacher";
    classes = userInfo["classes"];

    if (clss == null && classes.length != 0) clss = classes[0];

    return Scaffold(
      // floatingActionButton: !isTeacher
      //     ? null
      //     : FloatingActionButton(
      //         child: IconButton(
      //           onPressed: () async {
      //             await showPickerModal(context);
      //           },
      //           icon: Icon(Icons.filter_list),
      //         ),
      //         onPressed: () {},
      //       ),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        actions: [
          if (isTeacher)
            IconButton(
              onPressed: () async {
                await showPickerModal(context);
              },
              icon: const Icon(Icons.filter_list),
            ),
          // !isTeacher
          //     ? null
          //     : FloatingActionButton(
          //         child: IconButton(
          //           onPressed: () async {
          //             await showPickerModal(context);
          //           },
          //           icon: Icon(Icons.filter_list),
          //         ),
          //         onPressed: () {},
          //       )
        ],
        title: Text("Sınav Sonucu ${clss.toUpperCase()}"),
      ),
      body: ExamsList(clss),
    );
  }
}
