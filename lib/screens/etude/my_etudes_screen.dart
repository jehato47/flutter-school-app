import 'package:flutter/material.dart';
import 'package:school2/screens/etude/select_lecture_screen.dart';
import '../../widgets/etude/my_etudes/my_etudes_list.dart';

class MyEtudesScreen extends StatefulWidget {
  static const url = "my-etudes";
  @override
  _MyEtudesScreenState createState() => _MyEtudesScreenState();
}

class _MyEtudesScreenState extends State<MyEtudesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(SelectLectureScreen.url);
            },
          )
        ],
        title: Text("Etütlerim"),
      ),
      body: MyEtudesList(),
    );
  }
}
