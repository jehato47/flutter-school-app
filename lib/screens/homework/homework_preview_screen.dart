import 'package:flutter/material.dart';
import '../../widgets/homework/homeworks_list.dart';

class HomeworkPreviewScreen extends StatelessWidget {
  static const url = "/hw-preview";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ödevler"),
      ),
      body: HomeworksList(),
    );
  }
}
