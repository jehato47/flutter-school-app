import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FilesList extends StatefulWidget {
  final String uid;
  final String folderName;

  const FilesList(this.uid, this.folderName);

  @override
  _FilesListState createState() => _FilesListState();
}

class _FilesListState extends State<FilesList> {
  @override
  Widget build(BuildContext context) {
    String uid = widget.uid;
    String folderName = widget.folderName;

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("archive")
            .where("uid", isEqualTo: uid)
            .where("folderName", isEqualTo: folderName)
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          List<QueryDocumentSnapshot> items = snapshot.data.docs;
          items =
              items.where((element) => element["fileName"] != null).toList();
          if (items.isEmpty) {
            return const Center(
              child: Text("boş klasör"),
            );
          }
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) => ListTile(
              onLongPress: () async {
                await FirebaseFirestore.instance
                    .collection("archive")
                    .doc(items[index].id)
                    .delete();
                await FirebaseStorage.instance
                    .ref(items[index]["fileRef"])
                    .delete();
              },
              leading: const Icon(Icons.file_download),
              onTap: () {
                launch(items[index]["url"]);
              },
              title: Text(items[index]["fileName"]),
            ),
          );
        });
  }
}
