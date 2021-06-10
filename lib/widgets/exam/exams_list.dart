import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../screens/exam/add_exam_result_screen.dart';

class ExamsList extends StatefulWidget {
  @override
  _ExamsListState createState() => _ExamsListState();
}

class _ExamsListState extends State<ExamsList> {
  dynamic data;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("exam").snapshots(),
      // .where("classFirst", isEqualTo: "11")
      // .where("classLast", isEqualTo: "c")
      // .get(),

      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        data = snapshot.data.docs;
        return Padding(
            padding: EdgeInsets.all(10),
            child: ListView.builder(
              itemBuilder: (context, index) => Card(
                child: ListTile(
                  onTap: () {
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
    );
  }
}
