import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../widgets/homework/homework_history.dart';
import '../../widgets/homework/homework_form.dart';

class GiveHomeworkScreen extends StatefulWidget {
  static const url = "/give-homework";

  @override
  _GiveHomeworkScreenState createState() => _GiveHomeworkScreenState();
}

class _GiveHomeworkScreenState extends State<GiveHomeworkScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ödev Ver"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Container(
              width: kIsWeb ? 600 : null,
              child: Column(
                children: [
                  HomeworkForm(),
                  if (kIsWeb) SizedBox(height: 20),
                  HomeworkHistory(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
