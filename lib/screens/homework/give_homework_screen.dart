import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import '../../providers/homework.dart';
import '../../providers/auth.dart';
import 'package:flutter_picker/Picker.dart';
import '../../providers/attendance.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GiveHomeworkScreen extends StatefulWidget {
  static const url = "/give-homework";

  @override
  _GiveHomeworkScreenState createState() => _GiveHomeworkScreenState();
}

class _GiveHomeworkScreenState extends State<GiveHomeworkScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  bool isLoading = false;
  dynamic user;
  final _form = GlobalKey<FormState>();
  String token;
  File file;
  DateTime date;

  Map<String, dynamic> hw = {
    "classFirst": "11",
    "classLast": "a",
    "homework": null,
    "title": null,
    "dueDate": null,
    "explanation": null,
    "fileName": null,
  };

  void showDatePickerFunc() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 30)),
    ).then(
      (value) {
        if (value == null) return;

        setState(() {
          date = value;
          hw["dueDate"] = date;
        });
      },
    );
  }

  Future<void> pickFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      file = File(result.files.single.path);
      hw["fileName"] = file.path.split("/").last;
    });
  }

  Future<void> sendHomework() async {
    bool isValid = _form.currentState.validate();

    if (!isValid || date == null) return;

    _form.currentState.save();
    hw["teacher"] = auth.currentUser.displayName;
    hw["teacherImage"] = auth.currentUser.photoURL;
    hw["title"] = auth.currentUser.displayName;
    setState(() {
      isLoading = true;
    });
    await Provider.of<HomeWork>(context).addHomeWork(hw, file);
    setState(() {
      isLoading = false;
    });

    Navigator.of(context).pop();
  }

  showPickerModal(BuildContext context) async {
    FocusScope.of(context).requestFocus(new FocusNode());

    // TODO : todo
    // await Provider.of<Attendance>(context)
    //     .getAllClassNamesForAttendancePreview(token);
    // final allClasses = Provider.of<Attendance>(context).allClasses;
    final allClasses = [];

    new Picker(
        adapter: PickerDataAdapter<String>(pickerdata: allClasses),
        changeToFirst: true,
        hideHeader: false,
        confirmText: "Seç",
        cancelText: "Iptal",
        title: Text("Sınıf seç"),
        magnification: 1.2,
        onConfirm: (Picker picker, List value) {
          setState(() {
            hw["classFirst"] =
                picker.getSelectedValues().first.split("-").first;
            hw["classLast"] = picker.getSelectedValues().first.split("-").last;
          });
        }).showModal(this.context);
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<Auth>(context).userInform;
    token = Provider.of<Auth>(context).token;

    return Scaffold(
      appBar: AppBar(
        title: Text("Ödev Ver"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _form,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  validator: (value) {
                    if (value.isEmpty) return "Ödev girmediniz";
                    return null;
                  },
                  onSaved: (newValue) {
                    hw["homework"] = newValue;
                  },
                  decoration: InputDecoration(
                    labelText: "Ödev",
                    // border: OutlineInputBorder(),
                  ),
                ),
                TextFormField(
                  minLines: 2,
                  maxLines: 5,
                  validator: (value) {
                    if (value.isEmpty) return "Açıklama girmediniz";
                    return null;
                  },
                  onSaved: (newValue) {
                    hw["explanation"] = newValue;
                  },
                  decoration: InputDecoration(
                    labelText: "Açıklama",
                    alignLabelWithHint: true,
                    // border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: pickFile,
                        child: Text(
                          file != null
                              ? file.path.split("/").last
                              : "Dosya ekle",
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: showDatePickerFunc,
                        child: Text(
                          date != null
                              ? DateFormat('d MMMM').format(date)
                              : "Tarih Seç",
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          // TODO : Sınıf seçimini sayfa açıldığında yaptır
                          // TODO : Sadece Öğretmenin Girdiği Sınıfları Göster
                          showPickerModal(context);
                        },
                        child: Text(
                          hw["classFirst"] != null && hw["classLast"] != null
                              ? hw["classFirst"] + "-" + hw["classLast"]
                              : "Sınıf Seç",
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  child: isLoading
                      ? Center(child: CircularProgressIndicator())
                      : OutlinedButton(
                          onPressed: sendHomework,
                          child: Text("Gönder"),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
