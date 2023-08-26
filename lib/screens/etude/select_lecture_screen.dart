import 'package:flutter/material.dart';
import '../../widgets/etude/select_lecture/first_step_lecture_list.dart';

class SelectLectureScreen extends StatefulWidget {
  static const url = "select-lecture";
  @override
  _SelectLectureScreenState createState() => _SelectLectureScreenState();
}

class _SelectLectureScreenState extends State<SelectLectureScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Dersler"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: FirstStepLectureList(),
      ),
    );
  }
}
