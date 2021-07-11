import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'package:school2/providers/auth.dart';
import '../../providers/homework.dart';
import 'package:intl/intl.dart';
import 'package:flutter_picker/Picker.dart';

class HomeworkForm extends StatefulWidget {
  @override
  _HomeworkFormState createState() => _HomeworkFormState();
}

class _HomeworkFormState extends State<HomeworkForm> {
  dynamic userInfo;
  FirebaseAuth auth = FirebaseAuth.instance;

  bool isLoading = false;

  dynamic user;

  final _form = GlobalKey<FormState>();

  String token;

  dynamic file;

  DateTime date;

  Map<String, dynamic> hw = {
    "lecture": null,
    "classFirst": null,
    "classLast": null,
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
    if (kIsWeb) {
      setState(() {
        file = result.files.first.bytes;
        hw["fileName"] = result.files.first.name;
      });
    } else {
      setState(() {
        file = File(result.files.single.path);
        // TODO : Burayı 2 defa yazmaya gerek yok
        hw["fileName"] = result.files.first.name;
      });
    }
  }

  Future<void> sendHomework() async {
    bool isValid = _form.currentState.validate();

    if (!isValid || date == null) return;
    _form.currentState.save();

    date = null;

    hw["teacher"] = auth.currentUser.displayName;
    hw["teacherImage"] = auth.currentUser.photoURL;
    hw["uid"] = auth.currentUser.uid;
    hw["to"] = hw["classFirst"] + "-" + hw["classLast"];
    hw["lecture"] = userInfo["lecture"]; // TODO : 22
    // return;

    setState(() {
      isLoading = true;
    });
    await Provider.of<HomeWork>(context, listen: false).addHomeWork(hw, file);

    setState(() {
      _form.currentState.reset();

      isLoading = false;
      file = null;
      hw["classFirst"] = null;
      hw["classLast"] = null;
    });
  }

  showPickerModal(BuildContext context) async {
    FocusScope.of(context).requestFocus(new FocusNode());

    final allClasses = userInfo["classes"];

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

  Row helperButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: pickFile,
            child: Text(
              file != null ? hw["fileName"] : "Dosya ekle",
            ),
          ),
        ),
        SizedBox(width: 5),
        Expanded(
          child: OutlinedButton(
            onPressed: showDatePickerFunc,
            child: Text(
              date != null ? DateFormat('d MMMM').format(date) : "Tarih Seç",
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
    );
  }

  SizedBox sendButton() {
    return SizedBox(
      width: double.infinity,
      child: isLoading
          ? Center(child: CircularProgressIndicator())
          : OutlinedButton(
              onPressed: sendHomework,
              child: Text("Gönder"),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    userInfo = Provider.of<Auth>(context, listen: false).userInfo;
    return Form(
      key: _form,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            // controller: hwController,
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
          helperButtons(context),
          if (kIsWeb) SizedBox(height: 20),
          sendButton(),
        ],
      ),
    );
  }
}
