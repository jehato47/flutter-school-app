import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:school2/providers/auth.dart';
import '../../helpers/envs.dart';
import 'package:school2/providers/exam.dart';
import 'package:school2/providers/studentCheckBox/student_checkbox.dart';
import 'dart:io';
import '../../helpers/download/download_helper_provider.dart';
import 'package:provider/provider.dart';

class AddExamResultScreen extends StatefulWidget {
  static const url = "add-ex-res";

  @override
  _AddExamResultScreenState createState() => _AddExamResultScreenState();
}

class _AddExamResultScreenState extends State<AddExamResultScreen> {
  final baseUrl = Envs.baseUrl;
  String token;
  File file;
  bool isLoading = false;
  void pickFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["xlsx"],
    );
    if (result == null) return;

    setState(() {
      isLoading = true;
      file = File(result.files.single.path);
    });

    await Provider.of<Exam>(context).sendExcel(token, file.path);
    setState(() {
      isLoading = false;
    });
  }

  Future<void> downloadExcelByClasses(BuildContext context, url) async {
    final exam = await Provider.of<Exam>(context).getExcel(token, url);
    print(exam);
    await Provider.of<Download>(context).downloadFile(
      baseUrl + exam["file"],
    );
  }

  void showBottomSheet() {
    List<String> classes = [
      "11-a",
      "11-b",
      "11-c",
    ];
    List<String> selectedItems = [];
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: classes.length,
                itemBuilder: (context, index) {
                  return ChangeNotifierProvider.value(
                    value: StudentCheckBox(),
                    child: Consumer<StudentCheckBox>(
                      builder: (context, value, child) {
                        return CheckboxListTile(
                          value: value.isChecked,
                          onChanged: (v) {
                            value.change();
                            if (v)
                              selectedItems.add(classes[index]);
                            else {
                              selectedItems.removeWhere(
                                  (element) => element == classes[index]);
                            }
                          },
                          title: Text(classes[index]),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                String urlExtension = selectedItems.join("x");
                print(urlExtension);
                await downloadExcelByClasses(context, urlExtension);
                Navigator.of(context).pop();
              },
              child: Text("ok"),
            )
          ],
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    token = Provider.of<Auth>(context).token;
    return Scaffold(
      appBar: AppBar(
        title: Text("Sonuç Ekle"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    child: Text("Sonuçları yükle"),
                    onPressed: pickFile,
                  ),
            ElevatedButton(
              onPressed: showBottomSheet,
              child: Text("Sınıfları Seç"),
            )
          ],
        ),
      ),
    );
  }
}
