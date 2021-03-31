import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/notification.dart';
import '../../providers/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class NotificationScreen extends StatefulWidget {
  static const url = "/notification";
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  File file;
  dynamic user;
  TextEditingController mesaj = TextEditingController();
  final FocusNode focusNode = FocusNode();
  void pickFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      file = File(result.files.single.path);
    });

    // User canceled the picker
  }

  void addNotification() {
    mesaj.text = "";
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        // height: 300,
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Duyuru"),
              SizedBox(height: 20),
              TextField(
                focusNode: focusNode,
                controller: mesaj,
                decoration: InputDecoration(labelText: "Mesajı girin"),
                minLines: 3,
                maxLines: 4,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      pickFile();
                    },
                    child: Text("dosya ekle"),
                  ),
                  TextButton(
                    onPressed: () {
                      focusNode.unfocus();
                    },
                    child: Text("sınıf seç"),
                  ),
                ],
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Provider.of<NotificationP>(context).addNotification(
                      user["isim"] + " " + user["soyisim"],
                      mesaj.text,
                    );
                    Navigator.of(context).pop();
                  },
                  child: Text("Gönder"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<Auth>(context).userInform;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: addNotification,
          ),
        ],
        title: Text("Bildirimler"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("notification")
                .orderBy('added')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text("Something went wrong");
              }
              if (snapshot.connectionState == ConnectionState.waiting)
                return Center(
                  child: CircularProgressIndicator(),
                );
              CollectionReference ref =
                  FirebaseFirestore.instance.collection("notification");
              List docs = snapshot.data.documents;
              docs = List.from(docs.reversed);

              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) => Column(
                  children: [
                    ListTile(
                      onLongPress: () {
                        ref.doc(docs[index].id).delete();
                      },
                      selected: docs[index]["isSeen"],
                      leading: !docs[index]["isSeen"]
                          ? Icon(Icons.assignment)
                          : Icon(Icons.notification_important),
                      title: Text(
                        docs[index]["text"],
                      ),
                      subtitle: Text(docs[index]["oluşturan"]),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.file_present,
                        ),
                        onPressed: () {
                          ref.doc(docs[index].id).update({"isSeen": false});
                        },
                      ),
                    ),
                    Divider(
                      thickness: 1.2,
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
