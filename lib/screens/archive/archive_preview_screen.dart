import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:school2/screens/archive/teacher_archive_screen.dart';

class ArchivePreviewScreen extends StatefulWidget {
  static const url = "archive-preview";
  @override
  _ArchivePreviewScreenState createState() => _ArchivePreviewScreenState();
}

class _ArchivePreviewScreenState extends State<ArchivePreviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kaynaklar"),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("archive").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(
                child: CircularProgressIndicator(),
              );

            List<QueryDocumentSnapshot> items = snapshot.data.docs;

            Map teachers = {};
            items.forEach((element) {
              var uid = element["uid"];
              var displayName = element["displayName"];
              teachers[uid] = displayName;
            });

            if (teachers.isEmpty)
              return Center(
                child: Text("Henüz kaynak yok"),
              );
            return ListView.builder(
              itemCount: teachers.length,
              itemBuilder: (context, index) {
                String key = teachers.keys.elementAt(index);
                return ListTile(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      TeacherArchiveScreen.url,
                      arguments: key,
                    );
                  },
                  title: Text(teachers[key]),
                  trailing: Icon(Icons.source_outlined),
                );
              },
            );
          }),
    );
  }
}
