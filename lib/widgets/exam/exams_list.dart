import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../screens/exam/add_exam_result_screen.dart';

class ExamsList extends StatefulWidget {
  final String clss;
  const ExamsList(this.clss);

  @override
  _ExamsListState createState() => _ExamsListState();
}

class _ExamsListState extends State<ExamsList> {
  dynamic data;
  @override
  Widget build(BuildContext context) {
    if (widget.clss == null) {
      return const Center(
        child: Text("Henüz sınıf seçmediniz veya sınav bulunmamakta"),
      );
    }

    String classFirst = widget.clss.split("-").first;
    String classLast = widget.clss.split("-").last;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("exam")
          .where("classFirst", isEqualTo: classFirst)
          .where("classLast", isEqualTo: classLast)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        data = snapshot.data.docs;
        return Padding(
            padding: const EdgeInsets.all(10),
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
