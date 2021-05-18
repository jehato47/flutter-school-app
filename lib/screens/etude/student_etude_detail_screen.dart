import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StudentEtudeDetailScreen extends StatefulWidget {
  static const url = "student-etude-detail";
  @override
  _StudentEtudeDetailScreenState createState() =>
      _StudentEtudeDetailScreenState();
}

class _StudentEtudeDetailScreenState extends State<StudentEtudeDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final doc = ModalRoute.of(context).settings.arguments as dynamic;

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Öğrenci İsmi",
              style: TextStyle(fontSize: 30),
            ),
            Divider(),
            Text(
              doc["displayName"],
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Text(
              "Bırakılan Not",
              style: TextStyle(fontSize: 30),
            ),
            Divider(),
            Text(
              doc["note"],
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Text(
              "Ders",
              style: TextStyle(fontSize: 30),
            ),
            Divider(),
            Text(
              doc["lecture"],
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Text(
              "İstenme tarihi",
              style: TextStyle(fontSize: 30),
            ),
            Divider(),
            Text(
              DateFormat("dd-MM-yyyy HH:MM").format(doc["date"].toDate()),
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Divider(),
            Text(
              "Mevcut Etütler",
              style: TextStyle(fontSize: 30),
            ),
            Expanded(
              child: ListView(
                children: [
                  Text(
                    "qwe",
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
