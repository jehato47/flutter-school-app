import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'etudes_screen.dart';

class ShowEtudes extends StatefulWidget {
  static const url = "show-etudes";
  @override
  _ShowEtudesState createState() => _ShowEtudesState();
}

class _ShowEtudesState extends State<ShowEtudes> {
  @override
  Widget build(BuildContext context) {
    dynamic lectureTeachers = ModalRoute.of(context).settings.arguments;
    // dynamic lectureTeachers = args.docs
    //     .where((element) => element["lecture"] == "matematik")
    //     .toList();
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Öğretmenler",
              style: TextStyle(fontSize: 30),
            ),
            Divider(thickness: 1),
            Expanded(
              child: ListView.builder(
                itemCount: lectureTeachers.length,
                itemBuilder: (context, index) => ListTile(
                  trailing: Icon(Icons.arrow_forward),
                  contentPadding: EdgeInsets.all(0),
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      EtudesScreen.url,
                      arguments: lectureTeachers[index],
                    );
                  },
                  title: Text(
                    lectureTeachers[index]["displayName"],
                    style: TextStyle(fontSize: 20),
                  ),
                  // subtitle: Text(lectureTeachers[index][]),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
