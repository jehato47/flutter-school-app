import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import '../../providers/auth.dart';
import '../../providers/studentCheckBox/student_checkbox.dart';
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
  bool isActive = false;
  bool isLoading = false;

  dynamic user;

  final _form = GlobalKey<FormState>();

  late String token;

  dynamic file;

  late DateTime? date;

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
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    if (kIsWeb) {
      setState(() {
        file = result.files.first.bytes;
        hw["fileName"] = result.files.first.name;
      });
    } else {
      setState(() {
        file = File(result.files.single.path as String);
        // TODO : Burayı 2 defa yazmaya gerek yok
        hw["fileName"] = result.files.first.name;
      });
    }
  }

  List selecteds = [];
  Map tags2 = {
    "Önemli": Colors.green,
    "Yapmasanız da Olur": Colors.amber,
    "Kontrol Edilecek": Colors.orange,
    "Kesin Bitsin": Colors.red,
  };
  Future<void> sendHomework() async {
    // List<String> tags = [
    //   // "Türkçe",
    //   "Önemli",
    //   "Yapmasanız da Olur",
    //   "Kontrol Edilecek",
    //   "Kesin Bitsin"
    // ];

    // await showModalBottomSheet(
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.vertical(
    //       top: Radius.circular(20),
    //     ),
    //   ),
    //   context: context,
    //   builder: (context) => Container(
    //     // color: Colors.indigo,
    //     height: 300,
    //     padding: EdgeInsets.all(30),
    //     child: Wrap(
    //       spacing: 10,
    //       // runSpacing: 10,
    //       children: [
    //         ...tags2.entries.map((e) => ChangeNotifierProvider.value(
    //             value: StudentCheckBox(),
    //             child: Consumer<StudentCheckBox>(
    //               builder: (context, checkbox, child) {
    //                 // print(checkbox.isChecked);
    //                 // checkbox.isChecked;
    //                 return Chip(
    //                   deleteIcon: !checkbox.isChecked ? Icon(Icons.done) : null,
    //                   backgroundColor: checkbox.isChecked ? e.value : null,
    //                   onDeleted: () {
    //                     checkbox.change();

    //                     if (!selecteds.contains(e.key) && checkbox.isChecked)
    //                       selecteds.add(e.key);
    //                     else
    //                       selecteds.removeWhere((element) => element == e.key);
    //                     print(selecteds);
    //                   },
    //                   label: Text(e.key),
    //                 );
    //               },
    //             )))
    //         // ...tags2.entries.map(
    //         //   (entry) {
    //         //     return Chip(
    //         //       label: Text(entry.key),
    //         //     );
    //         //   },
    //         // ).toList()
    //       ],
    //     ),
    //   ),
    // );
    // return;
    bool isValid = _form.currentState!.validate();
    if (date == null) print(12212222);

    if (!isValid || date == null || hw["classFirst"] == null) return;
    _form.currentState!.save();

    // await showDialog(
    //   context: context,
    //   builder: (context) => AlertDialog(
    //     content: Column(
    //       mainAxisSize: MainAxisSize.min,
    //       children: [
    //         Wrap(
    //           children: [
    //             Chip(
    //               label: Text("Önemli"),
    //             ),
    //             Chip(
    //               label: Text("Önemli"),
    //             ),
    //             Chip(
    //               label: Text("Önemli"),
    //             ),
    //           ],
    //         ),
    //         Divider(),
    //         Wrap(
    //           children: [
    //             Chip(
    //               label: Text("Önemli"),
    //             ),
    //             Chip(
    //               label: Text("Önemli"),
    //             ),
    //             Chip(
    //               label: Text("Önemli"),
    //             ),
    //           ],
    //         )
    //       ],
    //     ),
    //   ),
    // );
    // return;
    date = null;

    hw["teacher"] = auth.currentUser!.displayName;
    hw["teacherImage"] = auth.currentUser!.photoURL;
    hw["uid"] = auth.currentUser!.uid;
    hw["to"] = hw["classFirst"] + "-" + hw["classLast"];
    hw["lecture"] = userInfo["lecture"]; // TODO : 22
    // return;

    setState(() {
      isLoading = true;
    });
    await Provider.of<HomeWork>(context, listen: false).addHomeWork(hw, file);

    setState(() {
      _form.currentState!.reset();

      isLoading = false;
      file = null;
      hw["classFirst"] = null;
      hw["classLast"] = null;
    });
    Navigator.of(context).pop();
  }

  showPickerModal(BuildContext context) async {
    FocusScope.of(context).requestFocus(FocusNode());

    final allClasses = userInfo["classes"];

    Picker(
        adapter: PickerDataAdapter<String>(pickerdata: allClasses),
        changeToFirst: true,
        hideHeader: false,
        confirmText: "Seç",
        cancelText: "Iptal",
        title: const Text("Sınıf seç"),
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
        const SizedBox(width: 5),
        Expanded(
          child: OutlinedButton(
            onPressed: showDatePickerFunc,
            child: Text(
              date != null
                  ? DateFormat('d MMMM').format(date as DateTime)
                  : "Tarih Seç",
            ),
          ),
        ),
        const SizedBox(width: 5),
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
          ? const Center(child: CircularProgressIndicator())
          : OutlinedButton(
              onPressed: sendHomework,
              child: const Text("Gönder"),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    userInfo = Provider.of<Auth>(context, listen: false).userInfo;
    return SingleChildScrollView(
      child: Form(
        key: _form,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              // controller: hwController,
              validator: (value) {
                if (value!.isEmpty) return "Ödev girmediniz";
                return null;
              },
              onSaved: (newValue) {
                hw["homework"] = newValue;
              },
              decoration: const InputDecoration(
                labelText: "Ödev",
                // border: OutlineInputBorder(),
              ),
            ),
            TextFormField(
              minLines: 2,
              maxLines: 5,
              validator: (value) {
                if (value!.isEmpty) return "Açıklama girmediniz";
                return null;
              },
              onSaved: (newValue) {
                hw["explanation"] = newValue;
              },
              decoration: const InputDecoration(
                labelText: "Açıklama",
                alignLabelWithHint: true,
                // border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 40),
            buildWrap(),
            const SizedBox(height: 20),
            helperButtons(context),
            if (kIsWeb) const SizedBox(height: 20),
            sendButton(),
          ],
        ),
      ),
    );
  }

  bool isOpen = true;
  AnimatedContainer buildWrap() {
    return AnimatedContainer(
      // height: !isOpen ? 10 : 100,
      duration: const Duration(milliseconds: 300),
      child: !isOpen
          ? Container()
          : Wrap(
              spacing: 10,
              // runSpacing: 10,
              children: [
                ...tags2.entries.map((e) => ChangeNotifierProvider.value(
                    value: StudentCheckBox(),
                    child: Consumer<StudentCheckBox>(
                      builder: (context, checkbox, child) {
                        // print(checkbox.isChecked);
                        // checkbox.isChecked;
                        return Chip(
                          deleteIcon:
                              !checkbox.isChecked ? Icon(Icons.done) : null,
                          backgroundColor: checkbox.isChecked ? e.value : null,
                          onDeleted: () {
                            checkbox.change();

                            if (!selecteds.contains(e.key) &&
                                checkbox.isChecked) {
                              selecteds.add(e.key);
                            } else {
                              selecteds
                                  .removeWhere((element) => element == e.key);
                            }
                            print(selecteds);
                          },
                          label: Text(e.key),
                        );
                      },
                    )))
                // ...tags2.entries.map(
                //   (entry) {
                //     return Chip(
                //       label: Text(entry.key),
                //     );
                //   },
                // ).toList()
              ],
            ),
    );
  }
}
