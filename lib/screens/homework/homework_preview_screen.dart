import 'package:flutter/material.dart';
import '../../widgets/homework/homework_preview_list.dart';

class HomeworkPreviewScreen extends StatelessWidget {
  static const url = "/hw-preview";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Homework Preview"),
      ),
      body: HomeworkPreviewList(),
    );
  }
}
