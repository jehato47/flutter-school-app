// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// import 'package:firebase_core/firebase_core.dart';
// import 'package:open_file/open_file.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/notification.dart';
import '../../providers/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';

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

  @override
  void initState() {
    final fbm = FirebaseMessaging.instance;
    fbm.requestPermission();
    fbm.subscribeToTopic("11-a");
    super.initState();
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
                      if (file != null) {
                        print(file.path);
                      }
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
                      mesaj.text.trim(),
                      file,
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

  void addToSeen(CollectionReference ref, DocumentSnapshot notification) {
    List list2 = notification["isSeen"];
    if (!list2.contains(user["user"])) {
      list2.add(user["user"]);
    }
    ref.doc(notification.id).update({"isSeen": list2});
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
              List docs = snapshot.data.docs;
              docs = List.from(docs.reversed);

              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot notification = docs[index];

                  return Column(
                    children: [
                      ListTile(
                        onLongPress: () {
                          ref.doc(notification.id).delete();
                        },
                        selected:
                            !notification["isSeen"].contains(user["user"]),
                        leading: notification["isSeen"].contains(user["user"])
                            ? Icon(Icons.assignment)
                            : Icon(Icons.notification_important),
                        title: Text(
                          notification["text"],
                        ),
                        subtitle: Text(notification["creator"]),
                        onTap: () {
                          // Görenlere ekliyor
                          addToSeen(ref, notification);
                        },
                        trailing: IconButton(
                          icon: Icon(
                            Icons.file_present,
                          ),
                          onPressed: notification["fileName"] == null
                              ? null
                              : () async {
                                  await Provider.of<NotificationP>(context)
                                      .downloadFileExample(
                                    notification.id,
                                    notification["fileName"],
                                  );
                                },
                        ),
                      ),
                      Divider(
                        thickness: 1.2,
                      ),
                    ],
                  );
                },
              );
            }),
      ),
    );
  }
}
