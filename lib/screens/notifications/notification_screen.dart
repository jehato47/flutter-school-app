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
import 'package:flutter_picker/Picker.dart';
import '../../providers/attendance.dart';
import '../../widgets/notification/notification_item.dart';
import '../../widgets/notification/notification_empty.dart';

class NotificationScreen extends StatefulWidget {
  static const url = "/notification";
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
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
                .orderBy('added')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print(snapshot.error);
                return Text("Birşeyler Ters Gitti");
              }
              if (snapshot.connectionState == ConnectionState.waiting)
                return Center(
                  child: CircularProgressIndicator(),
                );

              CollectionReference ref =
                  FirebaseFirestore.instance.collection("notification");

              List docs = snapshot.data.docs;
              docs = List.from(docs.reversed);

              return docs.length == 0
                  ? NotificationEmpty()
                  : ListView.builder(
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot notification = docs[index];

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
                    user["isim"] + " " + user["soyisim"],
                    mesaj.text.trim(),
                    file,
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
    final token = Provider.of<Auth>(context).token;
    await Provider.of<Attendance>(context)
        .getAllClassNamesForAttendancePreview(token);
    final allClasses = Provider.of<Attendance>(context).allClasses;

    new Picker(
        adapter: PickerDataAdapter<String>(pickerdata: allClasses),
        changeToFirst: true,
        hideHeader: false,
        confirmText: "Seç",
        cancelText: "Iptal",
        title: Text("Sınıf seç"),
        magnification: 1.2,
        onConfirm: (Picker picker, List value) {
          setState(() {});
        }).showModal(this.context);
  }
}
