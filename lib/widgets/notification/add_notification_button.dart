import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_picker/Picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import '../../providers/notification.dart';

class AddNotificationButton extends StatefulWidget {
  @override
  _AddNotificationButtonState createState() => _AddNotificationButtonState();
}

class _AddNotificationButtonState extends State<AddNotificationButton> {
  dynamic classes;
  String to;
  String fileName;
  FirebaseAuth auth = FirebaseAuth.instance;
  NotificationP notificationP;
  dynamic file;
  dynamic user;
  TextEditingController mesaj = TextEditingController();
  final FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    notificationP = Provider.of<NotificationP>(context);

    return IconButton(
      tooltip: "Duyuru ekle",
      icon: const Icon(Icons.add),
      onPressed: addNotification,
    );
  }

  showPickerModal(BuildContext context) async {
    final att = FirebaseFirestore.instance.collection('attendance');

    QuerySnapshot attendance = await att.get();

    classes = attendance.docs.map((e) => e.id).toList();
    classes.insert(0, "genel");
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SizedBox(
          width: 50,
          child: ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index) => ListTile(
              onTap: () {
                setState(() {
                  to = classes[index];
                });
                Navigator.of(context).pop();
              },
              title: Text(classes[index]),
            ),
            itemCount: classes.length,
          ),
        ),
      ),
    );
    return;
    // new Picker(
    //     adapter: PickerDataAdapter<String>(pickerdata: classes),
    //     changeToFirst: true,
    //     hideHeader: false,
    //     confirmText: "Seç",
    //     cancelText: "Iptal",
    //     diameterRatio: 1.5,
    //     magnification: 1.2,
    //     // title: Text(DateFormat('d MMMM').format(DateTime.now()).toString()),
    //     onConfirm: (Picker picker, List value) {
    //       setState(() {
    //         to = picker.getSelectedValues().first;
    //       });
    //       // print(picker.getSelectedValues().last);
    //     }).showModal(this.context);
  }

  void addNotification() async {
    mesaj.text = "";
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        scrollable: true,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Duyuru"),
            const SizedBox(height: 20),
            TextField(
              maxLength: 500,
              focusNode: focusNode,
              controller: mesaj,
              decoration: const InputDecoration(
                labelText: "Mesajı girin",
              ),
              minLines: 3,
              maxLines: 4,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: pickFile,
                  child: const Text("dosya ekle"),
                ),
                TextButton(
                  onPressed: () {
                    focusNode.unfocus();
                    showPickerModal(context);
                  },
                  child: const Text("sınıf seç"),
                ),
              ],
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (to == null) {
                    // Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        duration: Duration(milliseconds: 1000),
                        content: Text("Hedef kitleyi seçin"),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }
                  notificationP.addNotification(
                    auth.currentUser.displayName,
                    mesaj.text.trim(),
                    file,
                    fileName,
                    // TODO : production
                    // "11-a",
                    to,
                  );
                  file = null;
                  to = null;
                  Navigator.of(context).pop();
                },
                child: const Text("Gönder"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> pickFile() async {
    file = null;
    FilePickerResult result = await FilePicker.platform.pickFiles();

    if (result == null) return;
    fileName = result.files.first.name;

    if (kIsWeb) {
      setState(() {
        file = result.files.first.bytes;
      });
    } else {
      setState(() {
        file = File(result.files.single.path);
      });
    }
  }
}
