import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_picker/Picker.dart';
import '../../providers/notification.dart';
import '../../providers/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../widgets/notification/notification_item.dart';
import '../../widgets/notification/notification_empty.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationScreen extends StatefulWidget {
  static const url = "/notification";
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  dynamic classes;
  String to;

  FirebaseAuth auth = FirebaseAuth.instance;
  NotificationP notificationP;
  File file;
  dynamic user;
  TextEditingController mesaj = TextEditingController();
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    final fbm = FirebaseMessaging.instance;

    fbm.requestPermission();
    fbm.subscribeToTopic("11-a");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    notificationP = Provider.of<NotificationP>(context);
    user = Provider.of<Auth>(context).userInform;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            tooltip: "Duyuru ekle",
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
                .orderBy('added', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print(snapshot.error);
                return Center(child: Text("Birşeyler Ters Gitti..."));
              }
              if (snapshot.connectionState == ConnectionState.waiting)
                return Center(
                  child: CircularProgressIndicator(),
                );

              CollectionReference ref =
                  FirebaseFirestore.instance.collection("notification");

              List _docs = snapshot.data.docs;

              return _docs.length == 0
                  ? NotificationEmpty()
                  : ListView.builder(
                      itemCount: _docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot notification = _docs[index];

                        return Column(
                          children: [
                            NotificationItem(ref, notification, user),
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

  Future<void> pickFile() async {
    file = null;
    FilePickerResult result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      file = File(result.files.single.path);
    });
  }

  void addNotification() {
    mesaj.text = "";
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        scrollable: true,
        content: Column(
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
                  onPressed: pickFile,
                  child: Text("dosya ekle"),
                ),
                TextButton(
                  onPressed: () {
                    focusNode.unfocus();
                    showPickerModal(context);
                  },
                  child: Text("sınıf seç"),
                ),
              ],
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  notificationP.addNotification(
                    auth.currentUser.displayName,
                    mesaj.text.trim(),
                    file,
                    "11-a",
                  );
                  file = null;
                  Navigator.of(context).pop();
                },
                child: Text("Gönder"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  showPickerModal(BuildContext context) async {
    final att = FirebaseFirestore.instance.collection('attendance');

    QuerySnapshot attendance = await att.get();
    classes = attendance.docs.map((e) => e.id).toList();
    new Picker(
        adapter: PickerDataAdapter<String>(pickerdata: classes),
        changeToFirst: true,
        hideHeader: false,
        confirmText: "Seç",
        cancelText: "Iptal",
        diameterRatio: 1.5,
        magnification: 1.2,
        // title: Text(DateFormat('d MMMM').format(DateTime.now()).toString()),
        onConfirm: (Picker picker, List value) {
          setState(() {
            to = picker.getSelectedValues().first;
            // filteredDocs = [];
            print(to);
          });
          // print(picker.getSelectedValues().last);
        }).showModal(this.context);
  }
}
