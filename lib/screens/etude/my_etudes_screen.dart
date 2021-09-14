import 'package:flutter/material.dart';
import '../../screens/etude/select_lecture_screen.dart';
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await showModalBottomSheet(
            context: context,
            builder: (context) => SelectLectureScreen(),
          );
          // Navigator.of(context).pushNamed(SelectLectureScreen.url);
        },
      ),
      appBar: AppBar(
        actions: [
          // IconButton(
          //   icon: Icon(Icons.add),
          //   onPressed: () {
          //     Navigator.of(context).pushNamed(SelectLectureScreen.url);
          //   },
          // )
        ],
        title: Text("Etütlerim"),
      ),
      body: MyEtudesList(),
    );
  }
}
