import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_exam_result_screen.dart';

class StudentsExamList extends StatefulWidget {
  static const url = "exam-list";

  @override
  _StudentsExamListState createState() => _StudentsExamListState();
}

class _StudentsExamListState extends State<StudentsExamList> {
  dynamic data;

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Sınav Sonucu"),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection("exam")
            // .where("classFirst", isEqualTo: "11")
            // .where("classLast", isEqualTo: "c")
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());

          data = snapshot.data.docs;
          return Padding(
              padding: EdgeInsets.all(10),
              child: ListView.builder(
                itemBuilder: (context, index) => Card(
                  child: ListTile(
                    onTap: () {
                      print(data[index].id);
                      Navigator.of(context).pushNamed(
                        AddExamResultScreen.url,
                        arguments: [data, index],
                      );
                    },
                    title: Text(data[index]["displayName"]),
                    trailing: Text(
                      data[index]["number"].toString(),
                    ),
                  ),
                ),
                itemCount: data.length,
              ));
        },
      ),
    );
  }
}
