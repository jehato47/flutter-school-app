import 'package:flutter/material.dart';
import '../../screens/homework/give_homework_screen.dart';

class HomeworkButton extends StatefulWidget {
  @override
  _HomeworkButtonState createState() => _HomeworkButtonState();
}

class _HomeworkButtonState extends State<HomeworkButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 6.0),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.amber,
        ),
        margin: const EdgeInsets.all(8),
        child: IconButton(
          tooltip: "Ödev Ver",
          color: Colors.indigo,
          icon: const Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).pushNamed(GiveHomeworkScreen.url);
          },
        ),
      ),
    );
  }
}
