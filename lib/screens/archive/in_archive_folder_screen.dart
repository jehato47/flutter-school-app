import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';
import '../../providers/auth.dart';

class InArchiveFolderScreen extends StatefulWidget {
  @override
  _InArchiveFolderScreenState createState() => _InArchiveFolderScreenState();
}

class _InArchiveFolderScreenState extends State<InArchiveFolderScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final isTeacher = Provider.of<Auth>(context).userInfo["role"] == "teacher";
    final args = ModalRoute.of(context).settings.arguments as List;
    final folderName = args[0];
    final uid = args[1];
    bool isMe = auth.currentUser.uid == uid;

    return Scaffold(
      appBar: AppBar(
        actions: [
          if (isTeacher && isMe)
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () async {
                FilePickerResult result =
                    await FilePicker.platform.pickFiles(allowMultiple: true);

                if (result != null && kIsWeb) {
                  for (var file in result.files) {
                    dynamic fileBytes = file.bytes;
                    String fileName = file.name;
                    print(fileName);

                    await FirebaseStorage.instance
                        .ref('${auth.currentUser.uid}/$folderName/$fileName')
                        .putData(fileBytes)
                        .then((snapshot) async {
                      final url = await snapshot.ref.getDownloadURL();
                      await FirebaseFirestore.instance
                          .collection("archive")
                          .add({
                        "fileName": fileName,
                        "uid": auth.currentUser.uid,
                        "displayName": auth.currentUser.displayName,
                        "folderName": folderName,
                        "fileRef": snapshot.ref.fullPath,
                        "url": url,
                      });
                      print(snapshot.ref);
                    });
                  }
                } else if (result != null && !kIsWeb) {
                  List<File> files =
                      result.paths.map((path) => File(path)).toList();
                  for (var file in files) {
                    String fileName = file.path.split("/").last;
                    await FirebaseStorage.instance
                        .ref('${auth.currentUser.uid}/$folderName/$fileName')
                        .putFile(file)
                        .then((snapshot) async {
                      final url = await snapshot.ref.getDownloadURL();
                      await FirebaseFirestore.instance
                          .collection("archive")
                          .add({
                        "date": DateTime.now(),
                        "fileName": fileName,
                        "uid": auth.currentUser.uid,
                        "displayName": auth.currentUser.displayName,
                        "folderName": folderName,
                        "fileRef": snapshot.ref.fullPath,
                        "url": url,
                      });
                    });
                  }
                } else {}
              },
            ),
        ],
        title: Text(folderName),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("archive")
              .where("uid", isEqualTo: uid)
              .where("folderName", isEqualTo: folderName)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(
                child: CircularProgressIndicator(),
              );

            List<QueryDocumentSnapshot> items = snapshot.data.docs;
            items =
                items.where((element) => element["fileName"] != null).toList();
            if (items.isEmpty)
              return Center(
                child: Text("boş klasör"),
              );
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
                leading: Icon(Icons.file_download),
                onTap: () {
                  launch(items[index]["url"]);
                },
                title: Text(items[index]["fileName"]),
              ),
            );
          }),
    );
  }
}
