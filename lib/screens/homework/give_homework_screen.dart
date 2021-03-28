import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import '../../providers/homework.dart';
import '../../providers/auth.dart';

class GiveHomeworkScreen extends StatefulWidget {
  static const url = "/give-homework";

  @override
  _GiveHomeworkScreenState createState() => _GiveHomeworkScreenState();
}

class _GiveHomeworkScreenState extends State<GiveHomeworkScreen> {
  final _form = GlobalKey<FormState>();
  String token;
  File file;
  DateTime date;

  var hw = {
    "içerik": null,
    "başlık": null,
    "bitiş_tarihi": null,
    "sınıf": 11,
    "şube": "a",
    "açıklama": null,
    "file_path": null
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
          hw["bitiş_tarihi"] = DateFormat('yyyy-MM-dd').format(date);
        });
      },
    );
  }

  void pickFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      file = File(result.files.single.path);
      hw["file_path"] = file.path;
    });

    // User canceled the picker
  }

  void sendHomework() async {
    bool isValid = _form.currentState.validate();

    if (!isValid || file == null || date == null) return;

    _form.currentState.save();
    await Provider.of<HomeWork>(context).sendHomeWork(hw, token);
    print(12);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    token = Provider.of<Auth>(context).token;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.send),
            onPressed: sendHomework,
          )
        ],
        title: Text("Give Homework Screen"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Form(
            key: _form,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  validator: (value) {
                    if (value.isEmpty) return "başlık girmediniz";
                    return null;
                  },
                  onSaved: (newValue) {
                    hw["başlık"] = newValue;
                  },
                  decoration: InputDecoration(labelText: "başlık"),
                ),
                TextFormField(
                  validator: (value) {
                    if (value.isEmpty) return "içerik girmediniz";
                    return null;
                  },
                  onSaved: (newValue) {
                    hw["içerik"] = newValue;
                  },
                  decoration: InputDecoration(labelText: "içerik"),
                ),
                TextFormField(
                  minLines: 2,
                  maxLines: 5,
                  validator: (value) {
                    if (value.isEmpty) return "açıklama girmediniz";
                    return null;
                  },
                  onSaved: (newValue) {
                    hw["açıklama"] = newValue;
                  },
                  decoration: InputDecoration(
                    labelText: "açıklama",
                    alignLabelWithHint: true,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        pickFile();
                      },
                      child: Text(
                        file != null ? file.path.split("/").last : "Dosya ekle",
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        showDatePickerFunc();
                      },
                      child: Text(
                        date != null
                            ? DateFormat('d MMMM').format(date)
                            : "Tarih Seç",
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
