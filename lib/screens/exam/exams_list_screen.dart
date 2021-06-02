import 'package:flutter/material.dart';
import '../../widgets/exam/exams_list.dart';

class ExamsListScreen extends StatefulWidget {
  static const url = "exam-list";

  @override
  _ExamsListScreenState createState() => _ExamsListScreenState();
}

class _ExamsListScreenState extends State<ExamsListScreen> {
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Sınav Sonucu"),
      ),
      body: ExamsList(),
    );
  }
}
