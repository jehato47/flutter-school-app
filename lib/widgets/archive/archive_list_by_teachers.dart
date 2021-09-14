import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../screens/archive/teacher_archive_screen.dart';

class ArchiveListByTeachers extends StatefulWidget {
  @override
  _ArchiveListByTeachersState createState() => _ArchiveListByTeachersState();
}

class _ArchiveListByTeachersState extends State<ArchiveListByTeachers> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection("archive").snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          List<QueryDocumentSnapshot> items = snapshot.data.docs;

          Map teachers = {};
          items.forEach((element) {
            var uid = element["uid"];
            var displayName = element["displayName"];
            teachers[uid] = displayName;
          });

          if (teachers.isEmpty) {
            return const Center(
              child: Text("Henüz kaynak yok"),
            );
          }
          return ListView.builder(
            itemCount: teachers.length,
            itemBuilder: (context, index) {
              String uid = teachers.keys.elementAt(index);

              return ListTile(
                onTap: () {
                  Navigator.of(context).pushNamed(
                    TeacherArchiveScreen.url,
                    arguments: uid,
                  );
                },
                title: Text(teachers[uid]),
                trailing: const Icon(Icons.source_outlined),
              );
            },
          );
        });
  }
}
